//
//  UncompressedImageLoadingOperation.m
//  ImagePerformance
//
//  Created by Nick Lockwood on 10/05/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "UncompressedImageLoadingOperation.h"


@implementation UIImage (UncompressedData)

+ (UIImage *)imageWithBGRAData:(NSData *)data size:(CGSize)size scale:(CGFloat)scale
{
    NSUInteger width = size.width * scale;
    NSUInteger height = size.height * scale;

    CGBitmapInfo info = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((CFDataRef)data);
    CGImageRef imageRef = CGImageCreate(width, height, 8, 32, width * 4, colorSpace, info, dataProvider, NULL, false, (CGColorRenderingIntent)0);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    CGDataProviderRelease(dataProvider);
    CGColorSpaceRelease(colorSpace);
    
    return image;
}

- (NSData *)BGRAData
{
    NSUInteger width = self.size.width * self.scale;
    NSUInteger height = self.size.height * self.scale;
    NSUInteger bytes = width * height * 4;
    NSMutableData *data = [[NSMutableData alloc] initWithLength:bytes];

    CGBitmapInfo info = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data.mutableBytes, width, height, 8, width * 4, colorSpace, info);
    UIGraphicsPushContext(context);
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIGraphicsPopContext();
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return data;
}

@end


@interface ImageLoadingOperation (Private)

@property (nonatomic, assign) ImageLoadingOptions options;
@property (nonatomic, copy) NSString *nameOrPath;
@property (nonatomic, copy) ImageLoadingBlock block;
@property (nonatomic, assign) CGSize targetSize;

- (NSData *)fileDataForPath:(NSString *)path;

@end


@implementation UncompressedImageLoadingOperation

- (void)main
{
    CGSize targetSize = self.targetSize;
    NSParameterAssert(!CGSizeEqualToSize(targetSize, CGSizeZero));
    
    NSString *imagePath = self.nameOrPath;
    if (![imagePath isAbsolutePath])
    {
        imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imagePath];
    }
    
    NSTimeInterval start = CFAbsoluteTimeGetCurrent();
    
    NSData *data = [self fileDataForPath:imagePath];
    UIImage *image = [UIImage imageWithBGRAData:data size:targetSize scale:1];
    
    NSTimeInterval loaded = CFAbsoluteTimeGetCurrent();
    NSTimeInterval firstDrawn = loaded;
    
    if (self.options & ImageLoadingOptionIncludeDecoding)
    {
        //create context
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
        
        //first draw
        [image drawAtPoint:CGPointZero];

        UIGraphicsEndImageContext();
        
        firstDrawn = CFAbsoluteTimeGetCurrent();
    }
    
    NSTimeInterval finished = firstDrawn;
    
    if (self.options & ImageLoadingOptionIncludeDrawing)
    {
        //recreate context
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
        
        //second draw
        [image drawAtPoint:CGPointZero];
        
        UIGraphicsEndImageContext();
        
        finished = CFAbsoluteTimeGetCurrent();
    }
    
    //call block on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        self.block(image, image? loaded - start: 0, image? firstDrawn - loaded: 0, image? finished - firstDrawn: 0);
    });
}

@end
