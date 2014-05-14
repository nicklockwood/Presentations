//
//  ImageCarouselController.m
//  ImagePerformance
//
//  Created by Nick Lockwood on 19/04/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "ImageCarouselController.h"
#import "ImageLoadingOperation.h"


static NSArray *_imagePaths = nil;


@implementation ImageCarouselController

+ (void)load
{
    [self performSelectorOnMainThread:@selector(loadPaths) withObject:nil waitUntilDone:NO];
}

+ (void)loadPaths
{
    //get paths
    NSString *imagesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Lake"];
    NSMutableArray *imagePaths = [NSMutableArray array];
    for (NSString *path in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:imagesPath error:NULL])
    {
        [imagePaths addObject:[@"Lake" stringByAppendingPathComponent:path]];
    }
    _imagePaths = imagePaths;
}

- (void)awakeFromNib
{
    self.carousel.type = iCarouselTypeInvertedCylinder;
    self.carousel.hidden = YES;
}

- (void)didAppear
{
    [self clearAndReload];
    self.carousel.hidden = NO;
}

- (IBAction)clearAndReload
{
    [ImageLoadingOperation flushCaches];
    [self.carousel reloadData];
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_imagePaths count];
}

- (ImageLoadingOptions)options
{
    //set options
    ImageLoadingOptions options = ImageLoadingOptionsDefault;
    if (self.useImageNamedSwitch.on)
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
    if (self.createImageFromDataSwitch.on)
    {
        options |= ImageLoadingOptionCreateImageFromData;
    }
    if (self.predrawImageSwitch)
    {
        if (self.predrawImageSwitch.on)
        {
            options |= ImageLoadingOptionIncludeDecoding;
            self.useRedrawnImageSwitch.enabled = YES;
        }
        else
        {
            self.useRedrawnImageSwitch.enabled = NO;
            self.useRedrawnImageSwitch.on = NO;
        }
    }
    else
    {
        self.useRedrawnImageSwitch.enabled = YES;
    }
    if (self.useRedrawnImageSwitch.on || self.useRedrawnImage)
    {
        options |= ImageLoadingOptionIncludeDecoding;
        options |= ImageLoadingOptionUseRedrawnImage;
    }
    if (self.useImageIOSwitch)
    {
        if (self.useImageIOSwitch.on)
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
    }
    else
    {
        self.useImageIOCacheSwitch.enabled = YES;
        self.useImageIOCacheImmediatelySwitch.enabled = YES;
        self.useImageNamedSwitch.enabled = !(self.useImageIOCacheSwitch.on || self.useImageIOCacheImmediatelySwitch.on);
    }
    if (self.useImageIO)
    {
        options |= ImageLoadingOptionUseImageIO;
    }
    if (self.useImageIOCacheSwitch.on)
    {
        options |= ImageLoadingOptionUseImageIO;
        options |= ImageLoadingOptionUseImageIOCache;
    }
    if (self.useImageIOCacheImmediatelySwitch.on)
    {
        options |= ImageLoadingOptionUseImageIO;
        options |= ImageLoadingOptionUseImageIOCacheImmediately;
    }
    if (self.useNSCacheSwitch.on)
    {
        options |= ImageLoadingOptionUseNSCache;
    }

    return options;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 700, 500)];
    imageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    NSString *imagePath = _imagePaths[index];
    [[ImageLoadingOperation sharedStack] addOperation:[ImageLoadingOperation operationWithImageName:imagePath targetSize:self.targetSize options:[self options] block:^(UIImage *image, NSTimeInterval loadTime, NSTimeInterval firstDraw, NSTimeInterval secondDraw) {
        
        imageView.image = image;
    }]];

    return imageView;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionSpacing:
        {
            return 1.01;
        }
        case iCarouselOptionVisibleItems:
        {
            return 5;
        }
        case iCarouselOptionWrap:
        {
            return YES;
        }
        default:
        {
            return value;
        }
    }
}

@end
