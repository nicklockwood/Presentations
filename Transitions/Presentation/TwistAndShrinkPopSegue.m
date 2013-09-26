//
//  TwistAndExpandPopSegue.m
//  Presentation
//
//  Created by Nick Lockwood on 11/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "TwistAndShrinkPopSegue.h"
#import <QuartzCore/QuartzCore.h>

@implementation TwistAndShrinkPopSegue

- (void)perform
{
    //get navigation controller
    UINavigationController *nav = [self.sourceViewController navigationController];
    
    //get layer image for next screen
    UIView *destView = [self.destinationViewController view];
    destView.frame = [self.sourceViewController view].frame;
    UIGraphicsBeginImageContextWithOptions(destView.bounds.size, YES, 0.0);
    [destView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *revealImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //draw it in front of the current view
    UIView *revealView = [[UIImageView alloc] initWithImage:revealImage];
    [nav.view addSubview:revealView];
    
    //hide layer image initially
    CGAffineTransform transform = revealView.transform;
    transform = CGAffineTransformRotate(transform, M_PI_2);
    transform = CGAffineTransformScale(transform, 0.01, 0.01);
    revealView.transform = transform;
    
    //perform animation to dismiss reveal view
    [UIView animateWithDuration:1.0 animations:^{
        
        //restore view
        revealView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        //pop controller
        [nav popViewControllerAnimated:NO];
        
        //remove reveal view
        [revealView removeFromSuperview];
    }];
}

@end
