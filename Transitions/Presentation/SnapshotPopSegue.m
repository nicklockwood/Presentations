//
//  SnapshotPopSegue.m
//  Transitions
//
//  Created by Nick Lockwood on 21/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "SnapshotPopSegue.h"
#import <QuartzCore/QuartzCore.h>


@implementation SnapshotPopSegue

- (void)perform
{
    //get navigation controller
    UINavigationController *nav = [self.sourceViewController navigationController];
    
    //preserve current layer appearance
    UIView *fromView = [self.sourceViewController view];
    UIView *coverView = [fromView snapshotViewAfterScreenUpdates:YES];
    [nav.view addSubview:coverView];
    
    //get layer appearance for next screen
    UIView *destView = [self.destinationViewController view];
    destView.frame = nav.view.bounds;
    UIView *revealView = [destView snapshotViewAfterScreenUpdates:YES];
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
