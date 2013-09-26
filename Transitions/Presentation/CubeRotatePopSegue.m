//
//  CubeRotatePopSegue.m
//  Presentation
//
//  Created by Nick Lockwood on 21/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "CubeRotatePopSegue.h"
#import <QuartzCore/QuartzCore.h>


@implementation CubeRotatePopSegue

- (void)perform
{
    //get navigation controller
    UINavigationController *nav = [self.sourceViewController navigationController];
    
    //add background view
    UIView *backgroundView = [[UIView alloc] initWithFrame:nav.view.bounds];
    backgroundView.backgroundColor = [UIColor grayColor];
    [nav.view addSubview:backgroundView];
    
    //preserve current layer image
    UIView *fromView = [self.sourceViewController view];
    UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, YES, 0.0);
    [fromView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *coverImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //draw it in front of the current view
    UIView *coverView = [[UIImageView alloc] initWithImage:coverImage];
    coverView.layer.anchorPointZ = -coverView.frame.size.width / 2;
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / 1000;
    transform = CATransform3DTranslate(transform, 0, 0, coverView.layer.anchorPointZ);
    coverView.layer.transform = transform;
    [backgroundView addSubview:coverView];
    
    //get layer image for next screen
    UIView *destView = [self.destinationViewController view];
    destView.frame = [self.sourceViewController view].frame;
    UIGraphicsBeginImageContextWithOptions(destView.bounds.size, YES, 0.0);
    [destView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *revealImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //draw it behind the cover view
    UIView *revealView = [[UIImageView alloc] initWithImage:revealImage];
    revealView.layer.anchorPointZ = -revealView.frame.size.width / 2;
    transform = CATransform3DIdentity;
    transform.m34 = -1.0 / 1000;
    transform = CATransform3DTranslate(transform, 0, 0, revealView.layer.anchorPointZ);
    revealView.layer.transform = transform;
    [backgroundView insertSubview:revealView belowSubview:coverView];
    
    //move reveal view offscreen
    revealView.layer.transform = CATransform3DRotate(revealView.layer.transform, -M_PI_2, 0, 1, 0);
    
    //now we'll animate both our cover view and reveal view concurrently
    [UIView animateWithDuration:1 animations:^{
        
        revealView.layer.transform = CATransform3DRotate(revealView.layer.transform, M_PI_2, 0, 1, 0);
        coverView.layer.transform = CATransform3DRotate(coverView.layer.transform, M_PI_2, 0, 1, 0);
        
    } completion:^(BOOL finished){
        
        //pop controller
        [nav popViewControllerAnimated:NO];
        
        //remove views
        [coverView removeFromSuperview];
        [revealView removeFromSuperview];
        [backgroundView removeFromSuperview];
    }];
}

@end
