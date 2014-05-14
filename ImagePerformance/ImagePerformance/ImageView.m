//
//  ImageView.m
//  ImagePerformance
//
//  Created by Nick Lockwood on 24/04/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "ImageView.h"
#import "ImageLoadingOperation.h"

@implementation ImageView

- (void)setImagePath:(NSString *)imagePath
{
    _imagePath = imagePath;
    [[ImageLoadingOperation sharedQueue] addOperation:[ImageLoadingOperation operationWithImageName:self.imagePath targetSize:self.frame.size options:0 block:^(UIImage *image, NSTimeInterval loadTime, NSTimeInterval firstDraw, NSTimeInterval secondDraw) {
        
        [self.layer addAnimation:[CATransition animation] forKey:kCATransition];
        self.layer.contents = (id)image.CGImage;
        
    }]];
}

@end
