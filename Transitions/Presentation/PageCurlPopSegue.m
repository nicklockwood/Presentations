//
//  PageCurlPopSegue.m
//  Presentation
//
//  Created by Nick Lockwood on 10/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "PageCurlPopSegue.h"

@implementation PageCurlPopSegue

- (void)perform
{
    //preload the destination view and set its frame
    UIView *destinationView = [self.destinationViewController view];
    destinationView.frame = [self.sourceViewController view].frame;
    
    //perform transition between views
    [UIView transitionFromView:[self.sourceViewController view]
                        toView:destinationView
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlDown
                    completion:^(BOOL finised) {
        
        //pop controller
        [[self.sourceViewController navigationController] popViewControllerAnimated:NO];
    }];
}

@end
