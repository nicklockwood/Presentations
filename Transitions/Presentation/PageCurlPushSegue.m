//
//  PageCurlPushSegue.m
//  Presentation
//
//  Created by Nick Lockwood on 10/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "PageCurlPushSegue.h"

@implementation PageCurlPushSegue

- (void)perform
{
    //preload the destination view and set its frame
    UIView *destinationView = [self.destinationViewController view];
    destinationView.frame = [self.sourceViewController view].frame;
    
    //perform transition between views
    [UIView transitionFromView:[self.sourceViewController view]
                        toView:[self.destinationViewController view]
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlUp
                    completion:^(BOOL complete) {
    
        //push new controller
        UINavigationController *nav = [self.sourceViewController navigationController];
        [nav pushViewController:self.destinationViewController animated:NO];
    }];
}

@end
