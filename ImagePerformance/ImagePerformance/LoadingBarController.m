//
//  LoadingBarGraph.m
//  ImagePerformance
//
//  Created by Nick Lockwood on 28/03/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "LoadingBarController.h"
#import "ImageLoadingOperation.h"


@interface LoadingBarController ()

@property (nonatomic, assign) NSTimeInterval calculatedScale;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) BOOL queuedClear;
@property (nonatomic, assign) BOOL queuedReload;

@end


@implementation LoadingBarController

- (void)didAppear
{
    [self clearAndReload];
}

- (NSArray *)barViewsInView:(UIView *)view
{
    NSMutableArray *barViews = [NSMutableArray array];
    for (UIView *subview in view.subviews)
    {
        if ([subview isKindOfClass:[LoadingBar class]])
        {
            [barViews addObject:subview];
        }
        else
        {
            [barViews addObjectsFromArray:[self barViewsInView:subview]];
        }
    }
    return barViews;
}

- (IBAction)reload
{
    if (self.loading)
    {
        self.queuedReload = YES;
        return;
    }
    
    self.queuedReload = NO;
    self.loading = YES;
    
    __block NSInteger count = 0;
    
    //load images
    self.calculatedScale = 0;
    NSArray *barViews = [self barViewsInView:self];
    for (LoadingBar *barView in barViews)
    {
        //set options
        ImageLoadingOptions options = ImageLoadingOptionsDefault;
        if (!self.excludeDecoding)
        {
            options |= ImageLoadingOptionIncludeDecoding;
        }
        if (!self.excludeDrawing)
        {
            options |= ImageLoadingOptionIncludeDrawing;
        }
        
        if (self.useImageNamedSwitch? self.useImageNamedSwitch.on: barView.useImageNamed)
        {
            options |= ImageLoadingOptionUseImageNamed;
            self.createImageFromDataSwitch.enabled = NO;
            self.createImageFromDataSwitch.on = NO;
            self.useImageIOSwitch.enabled = NO;
            self.useImageIOSwitch.on = NO;
            self.useImageIOCacheSwitch.enabled = NO;
            self.useImageIOCacheSwitch.on = NO;
            self.useImageIOCacheImmediatelySwitch.enabled = NO;
            self.useImageIOCacheImmediatelySwitch.on = NO;
        }
        else
        {
            self.createImageFromDataSwitch.enabled = YES;
            self.useImageIOSwitch.enabled = YES;
        }
        if (self.createImageFromDataSwitch? self.createImageFromDataSwitch.on: (barView.createImageFromData || barView.useMappedData))
        {
            options |= ImageLoadingOptionCreateImageFromData;
            if (barView.useMappedData)
            {
                options |= ImageLoadingOptionUseMappedData;
            }
        }
        if (self.useRedrawnImageSwitch? self.useRedrawnImageSwitch.on: barView.useRedrawnImage)
        {
            options |= ImageLoadingOptionUseRedrawnImage;
        }
        if (self.useImageIOSwitch? self.useImageIOSwitch.on: barView.useImageIO)
        {
            options |= ImageLoadingOptionUseImageIO;
            self.useImageNamedSwitch.enabled = NO;
            self.useImageIOCacheSwitch.enabled = YES;
            self.useImageIOCacheImmediatelySwitch.enabled = YES;
        }
        else
        {
            self.useImageNamedSwitch.enabled = YES;
            self.useImageIOCacheSwitch.enabled = NO;
            self.useImageIOCacheSwitch.on = NO;
            self.useImageIOCacheImmediatelySwitch.enabled = NO;
            self.useImageIOCacheImmediatelySwitch.on = NO;
        }
        if (self.useImageIOCacheSwitch? self.useImageIOCacheSwitch.on: barView.useImageIOCache)
        {
            options |= ImageLoadingOptionUseImageIO;
            options |= ImageLoadingOptionUseImageIOCache;
        }
        if (self.useImageIOCacheImmediatelySwitch? self.useImageIOCacheImmediatelySwitch.on: barView.useImageIOCacheImmediately)
        {
            options |= ImageLoadingOptionUseImageIO;
            options |= ImageLoadingOptionUseImageIOCacheImmediately;
        }
        if (self.useNSCacheSwitch? self.useNSCacheSwitch.on: barView.useNSCache)
        {
            options |= ImageLoadingOptionUseNSCache;
        }
        
        //get image path
        NSString *imagePath = barView.imagePath;
        if (imagePath)
        {
            if (barView.extension) imagePath = [[imagePath stringByDeletingPathExtension] stringByAppendingPathExtension:barView.extension];
            barView.imageNameLabel.text = [imagePath lastPathComponent];
            barView.imageExtensionLabel.text = [imagePath pathExtension];
            
            //get image size
            NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imagePath];
            NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:NULL];
            long long bytes = [dict fileSize];
            double size = bytes;
            NSString *unit = @"bytes";
            if (size > 1024 * 1024)
            {
                unit = @"MB";
                size /= (1024 * 1024);
            }
            else if (size > 1024)
            {
                unit = @"KB";
                size /= 1024;
            }
            
            if (size)
            {
                barView.alpha = 1;
                barView.imageNameLabel.alpha = 1;
                barView.imageExtensionLabel.alpha = 1;
                barView.imageDimensionsLabel.alpha = 1;
                barView.imageDetailsLabel.alpha = 1;
                
                NSString *sizeString = [NSString stringWithFormat:@"%.1f %@", size, unit];
                barView.imageDetailsLabel.text = [[[barView.detailsFormat stringByReplacingOccurrencesOfString:@"$ext" withString:[imagePath pathExtension]] stringByReplacingOccurrencesOfString:@"$name" withString:[imagePath lastPathComponent]] stringByReplacingOccurrencesOfString:@"$size" withString:sizeString];
                
                //load image
                [[ImageLoadingOperation sharedQueue] addOperation:[ImageLoadingOperation operationWithImageName:imagePath targetSize:self.targetSize options:options block:^(UIImage *image, NSTimeInterval loadTime, NSTimeInterval firstDraw, NSTimeInterval secondDraw) {
                    
                    count++;
                    self.calculatedScale = MAX(self.calculatedScale, loadTime + firstDraw + secondDraw);
                    [barView setScale:self.timeScale loadTime:loadTime firstDraw:firstDraw secondDraw:secondDraw animated:YES];
                    
                    //set image
                    barView.imageView.image = image;
                    
                    //set details
                    NSString *dimensions = [NSString stringWithFormat:@"%.0f x %.0f px", image.size.width * image.scale, image.size.height * image.scale];
                    barView.imageDimensionsLabel.text = dimensions;
                    barView.imageDetailsLabel.text = [barView.imageDetailsLabel.text stringByReplacingOccurrencesOfString:@"$dimensions" withString:dimensions];
                    
                    if (count == [barViews count])
                    {
                        if (self.timeScale < self.calculatedScale)
                        {
                            for (LoadingBar *otherBarView in barViews)
                            {
                                [otherBarView setScale:self.calculatedScale animated:YES];
                            }
                        }
                        
                        [self loadEnded];
                    }
                    
                }]];
            }
            else
            {
                count++;
                
                barView.alpha = 0;
                barView.imageNameLabel.alpha = 0;
                barView.imageExtensionLabel.alpha = 0;
                barView.imageDimensionsLabel.alpha = 0;
                barView.imageDetailsLabel.alpha = 0.25;
                
                [barView setScale:0 loadTime:0 firstDraw:0 secondDraw:0 animated:YES];
                barView.imageDetailsLabel.text = [[[[barView.detailsFormat stringByReplacingOccurrencesOfString:@"$ext" withString:[imagePath pathExtension]] stringByReplacingOccurrencesOfString:@"$name" withString:@"N/A"] stringByReplacingOccurrencesOfString:@"$size" withString:@"N/A"] stringByReplacingOccurrencesOfString:@"$dimensions" withString:@"N/A"];
                
                if (count == [barViews count])
                {
                    [self loadEnded];
                }
            }
        }
        else
        {
            count++;
            
            if (count == [barViews count])
            {
                [self loadEnded];
            }
        }
    }
}

- (void)loadEnded
{
    self.loading = NO;
    if (self.queuedClear)
    {
        [self clearCache];
    }
    if (self.queuedReload)
    {
        [self reload];
    }
}

- (IBAction)clearCache
{
    if (self.loading)
    {
        self.queuedClear = YES;
        return;
    }
    
    self.queuedClear = NO;
    
    [ImageLoadingOperation flushCaches];
}

- (IBAction)clearAndReload
{
    [self clearCache];
    [self reload];
}

- (void)setImagePath:(NSString *)imagePath
{
    for (LoadingBar *barView in [self barViewsInView:self])
    {
        barView.imagePath = imagePath;
    }
    [self clearAndReload];
}

@end
