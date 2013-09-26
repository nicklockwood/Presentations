//
//  TwistAndShrinkPushSegue.m
//  Presentation
//
//  Created by Nick Lockwood on 11/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "TwistAndShrinkPushSegue.h"
#import <QuartzCore/QuartzCore.h>

@implementation TwistAndShrinkPushSegue

- (void)perform
{
    //get navigation controller
    UINavigationController *nav = [self.sourceViewController navigationController];
    
    //preserve current layer image
    UIView *fromView = [self.sourceViewController view];
    UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, YES, 0.0);
    [fromView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *coverImage = UIGraphicsGetImageFromCurrentImageContext();

    //draw it in front of the current view
    UIView *coverView = [[UIImageView alloc] initWithImage:coverImage];
    [nav.view addSubview:coverView];

    //push new controller
    [nav pushViewController:self.destinationViewController animated:NO];
    
    //perform animation to dismiss cover view
    [UIView animateWithDuration:1.0 animations:^{
        
        //rotate and shrink view
        CGAffineTransform transform = coverView.transform;
        transform = CGAffineTransformRotate(transform, M_PI_2);
        transform = CGAffineTransformScale(transform, 0.01, 0.01);
        coverView.transform = transform;
        
    } completion:^(BOOL finished) {
        
        //remove cover view
        [coverView removeFromSuperview];
    }];
}

@end
