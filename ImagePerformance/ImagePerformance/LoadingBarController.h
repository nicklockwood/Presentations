//
//  LoadingBarGraph.h
//  ImagePerformance
//
//  Created by Nick Lockwood on 28/03/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingBar.h"
#import "ImagePickerView.h"


@interface LoadingBarController : UIView <ImagePickerDelegate>

@property (nonatomic, assign) BOOL excludeDrawing;
@property (nonatomic, assign) BOOL excludeDecoding;
@property (nonatomic, assign) CGSize targetSize;
@property (nonatomic, assign) NSTimeInterval timeScale;

@property (nonatomic, strong) IBOutlet UISwitch *useImageNamedSwitch;
@property (nonatomic, strong) IBOutlet UISwitch *createImageFromDataSwitch;
@property (nonatomic, assign) IBOutlet UISwitch *useRedrawnImageSwitch;
@property (nonatomic, assign) IBOutlet UISwitch *useImageIOSwitch;
@property (nonatomic, assign) IBOutlet UISwitch *useImageIOCacheSwitch;
@property (nonatomic, assign) IBOutlet UISwitch *useImageIOCacheImmediatelySwitch;
@property (nonatomic, assign) IBOutlet UISwitch *useNSCacheSwitch;

- (IBAction)reload;
- (IBAction)clearCache;
- (IBAction)clearAndReload;

@end
