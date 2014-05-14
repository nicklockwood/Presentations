//
//  ImagePickerView.h
//  ImagePerformance
//
//  Created by Nick Lockwood on 07/04/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ImagePickerDelegate <NSObject>

- (void)setImagePath:(NSString *)path;

@end


@interface ImagePickerView : UIView

@property (nonatomic, assign) BOOL hideExtensions;
@property (nonatomic, weak) IBOutlet id<ImagePickerDelegate> delegate;

@end
