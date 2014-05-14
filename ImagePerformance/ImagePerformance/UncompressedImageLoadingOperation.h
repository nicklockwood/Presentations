//
//  UncompressedImageLoadingOperation.h
//  ImagePerformance
//
//  Created by Nick Lockwood on 10/05/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageLoadingOperation.h"


@interface UIImage (UncompressedData)

+ (UIImage *)imageWithBGRAData:(NSData *)data size:(CGSize)size scale:(CGFloat)scale;
- (NSData *)BGRAData;

@end


@interface UncompressedImageLoadingOperation : ImageLoadingOperation

@end