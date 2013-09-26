//
//  UIKitAnimationView.m
//  Presentation
//
//  Created by Nick Lockwood on 06/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "UIKitAnimationView.h"

@implementation UIKitAnimationView

- (IBAction)animate
{
    //perform animation
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformRotate(self.transform, M_PI_2);
        self.backgroundColor = [UIColor colorWithRed:drand48()*0.75
                                               green:drand48()*0.75
                                                blue:drand48()*0.75
                                               alpha:1.0];
    }];
}

@end
