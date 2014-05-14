//
//  ImageLoadingOperation.m
//  ImagePerformance
//
//  Created by Nick Lockwood on 24/03/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "ImageLoadingOperation.h"
#import <ImageIO/ImageIO.h>
#import "UncompressedImageLoadingOperation.h"


@interface UIImage (private)

//provate method - not for production use
+ (void)_flushSharedImageCache;

@end


@interface ImageLoadingOperation ()

@property (nonatomic, assign) ImageLoadingOptions options;
@property (nonatomic, copy) NSString *nameOrPath;
@property (nonatomic, copy) ImageLoadingBlock block;
@property (nonatomic, assign) CGSize targetSize;

@end


@implementation ImageLoadingOperation

+ (NSOperationQueue *)sharedQueue
{
    static NSOperationQueue *sharedQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQueue = [[NSOperationQueue alloc] init];
        sharedQueue.maxConcurrentOperationCount = 1;
    });
    
    return sharedQueue;
}

+ (NSOperationStack *)sharedStack
{
    static NSOperationStack *sharedQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQueue = [[NSOperationStack alloc] init];
        sharedQueue.maxConcurrentOperationCount = 3;
    });
    
    return sharedQueue;
}

+ (NSCache *)sharedCache
{
    static NSCache *sharedCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[NSCache alloc] init];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

            [sharedCache removeAllObjects];
        }];
    });
    
    return sharedCache;
}

+ (void)flushCaches
{
    [[self sharedStack] cancelAllOperations];
    [[self sharedQueue] cancelAllOperations];
    [[self sharedCache] removeAllObjects];
    [UIImage _flushSharedImageCache];
}

+ (instancetype)operationWithImageName:(NSString *)nameOrPath targetSize:(CGSize)size options:(ImageLoadingOptions)options block:(ImageLoadingBlock)block
{
    if (self != [UncompressedImageLoadingOperation class] && [[nameOrPath pathExtension] isEqualToString:@"bgra"])
    {
        return [UncompressedImageLoadingOperation operationWithImageName:nameOrPath targetSize:size options:options block:block];
    }
    
    ImageLoadingOperation *operation = [[self alloc] init];
    operation.threadPriority = 1;
    operation.options = options;
    operation.nameOrPath = nameOrPath;
    operation.targetSize = size;
    operation.block = block;
    return operation;
}

- (NSString *)cacheKey
{
    NSString *cacheKey = self.nameOrPath;
    if (self.options & ImageLoadingOptionUseImageNamed)
    {
        cacheKey = [cacheKey stringByAppendingPathExtension:@"named"];
    }
    if (self.options & ImageLoadingOptionUseRedrawnImage)
    {
        cacheKey = [cacheKey stringByAppendingPathExtension:@"redrawn"];
    }
    return cacheKey;
}

- (NSData *)fileDataForPath:(NSString *)path
{
    if (self.options & ImageLoadingOptionUseMappedData)
    {
        return [NSData dataWithContentsOfFile:path options:NSDataReadingMappedAlways error:NULL];
    }
    else
    {
        return [NSData dataWithContentsOfFile:path];
    }
}

- (void)main
{
    NSTimeInterval start = CFAbsoluteTimeGetCurrent();
    
    //load image
    UIImage *image = nil;
    BOOL cached = NO;
    if (self.options & ImageLoadingOptionUseNSCache)
    {
        image = [[[self class] sharedCache] objectForKey:[self cacheKey]];
        if (image)
        {
            cached = YES;
        }
    }
    if (!image)
    {
        if (self.options & ImageLoadingOptionUseImageNamed)
        {
            image = [UIImage imageNamed:self.nameOrPath];
        }
        else
        {
            NSString *imagePath = self.nameOrPath;
            if (![imagePath isAbsolutePath])
            {
                imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imagePath];
            }
            
            if (self.options & ImageLoadingOptionUseImageIO)
            {
                NSDictionary *options = @{(id)kCGImageSourceShouldCache: (self.options & ImageLoadingOptionUseImageIOCache)? @YES: @NO,
                                          (id)kCGImageSourceShouldCacheImmediately: (self.options & ImageLoadingOptionUseImageIOCacheImmediately)? @YES: @NO};
                
                BOOL useThumbnail = !CGSizeEqualToSize(self.targetSize, CGSizeZero);
                if (useThumbnail)
                {
                    CGFloat size = MAX(self.targetSize.width, self.targetSize.height) * [UIScreen mainScreen].scale;
                    options = @{(id)kCGImageSourceCreateThumbnailFromImageAlways: @YES, (id)kCGImageSourceThumbnailMaxPixelSize: @(size)};
                }
                
                CGImageSourceRef src = NULL;
                if (self.options & ImageLoadingOptionCreateImageFromData || self.options & ImageLoadingOptionUseMappedData)
                {
                    NSData *data = [self fileDataForPath:imagePath];
                    src = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
                }
                else
                {
                    NSURL *URL = [NSURL fileURLWithPath:imagePath];
                    src = CGImageSourceCreateWithURL((__bridge CFURLRef)URL, NULL);
                }
            
                CGImageRef imageRef = NULL;
                if (useThumbnail)
                {
                    imageRef = CGImageSourceCreateThumbnailAtIndex(src, 0, (__bridge CFDictionaryRef)options);
  
                }
                else
                {
                    imageRef = CGImageSourceCreateImageAtIndex(src, 0, (__bridge CFDictionaryRef)options);
                }
                image = [[UIImage alloc] initWithCGImage:imageRef];
                CGImageRelease(imageRef);
                CFRelease(src);
            }
            else if (self.options & ImageLoadingOptionCreateImageFromData || self.options & ImageLoadingOptionUseMappedData)
            {
                NSData *data = [self fileDataForPath:imagePath];
                image = [UIImage imageWithData:data];
            }
            else
            {
                image = [UIImage imageWithContentsOfFile:imagePath];
            }
        }
    }
    
    NSTimeInterval loaded = CFAbsoluteTimeGetCurrent();
    NSTimeInterval firstDrawn = loaded;
    
    BOOL useRedrawnImage = self.options & ImageLoadingOptionUseRedrawnImage;
    CGSize targetSize = (!useRedrawnImage || CGSizeEqualToSize(self.targetSize, CGSizeZero))? image.size: self.targetSize;
    CGFloat targetScale = (!useRedrawnImage || CGSizeEqualToSize(self.targetSize, CGSizeZero))? image.scale: 0;
    CGRect targetRect = {CGPointZero, targetSize};
    
    if (!cached && (useRedrawnImage || self.options & ImageLoadingOptionIncludeDecoding))
    {
        //create context
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, targetScale);
        
        //first draw
        [image drawInRect:targetRect];
        if (useRedrawnImage)
        {
            //use redrawn image
            image = UIGraphicsGetImageFromCurrentImageContext();
        }
    
        UIGraphicsEndImageContext();
        
        firstDrawn = CFAbsoluteTimeGetCurrent();
    }

    NSTimeInterval finished = firstDrawn;
    
    if (self.options & ImageLoadingOptionIncludeDrawing)
    {
        //recreate context
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, targetScale);
        
        //second draw
        [image drawInRect:targetRect];
    
        UIGraphicsEndImageContext();
        
        finished = CFAbsoluteTimeGetCurrent();
    }
    
    if (!cached && image && self.options & ImageLoadingOptionUseNSCache)
    {
        [[[self class] sharedCache] setObject:image forKey:[self cacheKey]];
    }
    
    //call block on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        self.block(image, image? loaded - start: 0, image? firstDrawn - loaded: 0, image? finished - firstDrawn: 0);
    });
}

@end
