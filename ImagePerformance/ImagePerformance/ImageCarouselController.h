//
//  ImageCarouselController.h
//  ImagePerformance
//
//  Created by Nick Lockwood on 19/04/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface ImageCarouselController : UIView <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, assign) CGSize targetSize;
@property (nonatomic, assign) BOOL useImageIO;
@property (nonatomic, assign) BOOL useRedrawnImage;

@property (nonatomic, strong) IBOutlet iCarousel *carousel;

@property (nonatomic, strong) IBOutlet UISwitch *useImageNamedSwitch;
@property (nonatomic, strong) IBOutlet UISwitch *createImageFromDataSwitch;
@property (nonatomic, assign) IBOutlet UISwitch *predrawImageSwitch;
@property (nonatomic, assign) IBOutlet UISwitch *useRedrawnImageSwitch;
@property (nonatomic, assign) IBOutlet UISwitch *useImageIOSwitch;
@property (nonatomic, assign) IBOutlet UISwitch *useImageIOCacheSwitch;
@property (nonatomic, assign) IBOutlet UISwitch *useImageIOCacheImmediatelySwitch;
@property (nonatomic, assign) IBOutlet UISwitch *useNSCacheSwitch;

- (IBAction)clearAndReload;

@end
