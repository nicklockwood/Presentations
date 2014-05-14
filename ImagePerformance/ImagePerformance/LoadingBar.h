//
//  BarView.h
//  ImagePerformance
//
//  Created by Nick Lockwood on 29/03/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePickerView.h"


@interface LoadingBar : UIView <ImagePickerDelegate>

@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *extension;
@property (nonatomic, copy) NSString *detailsFormat;
@property (nonatomic, assign) BOOL useImageNamed;
@property (nonatomic, assign) BOOL createImageFromData;
@property (nonatomic, assign) BOOL useMappedData;
@property (nonatomic, assign) BOOL useRedrawnImage;
@property (nonatomic, assign) BOOL useImageIO;
@property (nonatomic, assign) BOOL useImageIOCache;
@property (nonatomic, assign) BOOL useImageIOCacheImmediately;
@property (nonatomic, assign) BOOL useNSCache;

@property (nonatomic, strong) IBOutlet UILabel *imageNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *imageDimensionsLabel;
@property (nonatomic, strong) IBOutlet UILabel *imageExtensionLabel;
@property (nonatomic, strong) IBOutlet UILabel *imageDetailsLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

- (void)setScale:(NSTimeInterval)scale
        animated:(BOOL)animated;

- (void)setScale:(NSTimeInterval)scale
        loadTime:(NSTimeInterval)loadTime
       firstDraw:(NSTimeInterval)firstDraw
      secondDraw:(NSTimeInterval)secondDraw
        animated:(BOOL)animated;

@end
