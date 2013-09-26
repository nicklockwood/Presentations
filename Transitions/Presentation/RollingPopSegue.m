//
//  RollingPopSegue.m
//  Presentation
//
//  Created by Nick Lockwood on 12/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "RollingPopSegue.h"
#import <QuartzCore/QuartzCore.h>

@implementation RollingPopSegue

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
    
    //get layer image for next screen
    UIView *destView = [self.destinationViewController view];
    destView.frame = [self.sourceViewController view].frame;
    UIGraphicsBeginImageContextWithOptions(destView.bounds.size, YES, 0.0);
    [destView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *revealImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //draw it behind the cover view
    UIView *revealView = [[UIImageView alloc] initWithImage:revealImage];
    [nav.view insertSubview:revealView belowSubview:coverView];
    
    //now we need to add some kind of background view to show behind our animating views
	//we'll insert this undeneath both the other views
	UIView *backgroundView = [[UIView alloc] initWithFrame:nav.view.bounds];
	backgroundView.backgroundColor = [UIColor grayColor];
	[nav.view insertSubview:backgroundView belowSubview:revealView];
    
    //now we'll animate both our cover view and reveal view concurrently
	revealView.transform = CGAffineTransformRotate(CGAffineTransformMakeTranslation(-revealView.frame.size.width, 0), -M_PI_2);
	[UIView animateWithDuration:1 animations:^{
        
		revealView.transform = CGAffineTransformIdentity;
		coverView.transform = CGAffineTransformRotate(CGAffineTransformMakeTranslation(revealView.frame.size.width, 0), -M_PI_2);
		coverView.alpha = 0.0;
        
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
