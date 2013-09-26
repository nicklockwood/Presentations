//
//  SnapshotPushSegue.m
//  Transitions
//
//  Created by Nick Lockwood on 21/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "SnapshotPushSegue.h"
#import <QuartzCore/QuartzCore.h>


@implementation SnapshotPushSegue

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
    
    //push new controller
    [nav pushViewController:self.destinationViewController animated:NO];
    
    //move reveal view offscreen
    CGAffineTransform transform = CGAffineTransformMakeTranslation(revealView.frame.size.width, 0);
    revealView.transform = CGAffineTransformRotate(transform, M_PI_2);
    
    //now we'll animate both our cover view and reveal view concurrently
    [UIView animateWithDuration:1 animations:^{
        
        revealView.transform = CGAffineTransformIdentity;
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-revealView.frame.size.width, 0);
        coverView.transform = CGAffineTransformRotate(transform, M_PI_2);
        coverView.alpha = 0.0;
        
    } completion:^(BOOL finished){
        
        //remove views
        [coverView removeFromSuperview];
        [revealView removeFromSuperview];
        [backgroundView removeFromSuperview];
    }];
}

@end
