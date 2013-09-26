//
//  ZoomInLabel.m
//  Transitions
//
//  Created by Nick Lockwood on 24/09/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "ZoomInLabel.h"


@interface ZoomInLabel ()

@property (nonatomic, assign) BOOL alreadyAnimated;

@end


@implementation ZoomInLabel

- (void)awakeFromNib
{
    if (!self.alreadyAnimated)
    {
        self.alreadyAnimated = YES;
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.alpha = 0.0f;
        
        __weak ZoomInLabel *weakSelf = self;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delay * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:weakSelf.duration animations:^{
                
                weakSelf.transform = CGAffineTransformIdentity;
                weakSelf.alpha = 1.0f;
            }];
        });
    }
    else
    {
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    }
}

@end
