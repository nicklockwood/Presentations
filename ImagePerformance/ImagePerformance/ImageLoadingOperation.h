//
//  ImageLoadingOperation.h
//  ImagePerformance
//
//  Created by Nick Lockwood on 24/03/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSOperationStack.h"


typedef NS_OPTIONS(NSInteger, ImageLoadingOptions)
{
    ImageLoadingOptionsDefault = 0,
    ImageLoadingOptionIncludeDrawing = 1,
    ImageLoadingOptionIncludeDecoding = 2,
    ImageLoadingOptionUseImageNamed = 4,
    ImageLoadingOptionCreateImageFromData = 8,
    ImageLoadingOptionUseMappedData = 16,
    ImageLoadingOptionUseRedrawnImage = 32,
    ImageLoadingOptionUseImageIO = 64,
    ImageLoadingOptionUseImageIOCache = 128,
    ImageLoadingOptionUseImageIOCacheImmediately = 256,
    ImageLoadingOptionUseNSCache = 512
};


typedef void (^ImageLoadingBlock)(UIImage *image, NSTimeInterval loadTime, NSTimeInterval firstDraw, NSTimeInterval secondDraw);


@interface ImageLoadingOperation : NSOperation

+ (NSOperationQueue *)sharedQueue;
+ (NSOperationStack *)sharedStack;
+ (NSCache *)sharedCache;
+ (void)flushCaches;

+ (instancetype)operationWithImageName:(NSString *)nameOrPath targetSize:(CGSize)size options:(ImageLoadingOptions)options block:(ImageLoadingBlock)block;

@end
