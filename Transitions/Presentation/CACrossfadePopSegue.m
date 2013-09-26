//
//  CACrossfadePopSegue.m
//  Presentation
//
//  Created by Nick Lockwood on 11/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "CACrossfadePopSegue.h"
#import <QuartzCore/QuartzCore.h>

@implementation CACrossfadePopSegue

- (void)perform
{
    //get navigation controller
    UINavigationController *nav = [self.sourceViewController navigationController];
    
    //perform transition
    CATransition *transition = [CATransition animation];
    transition.timingFunction = [CAMediaTimingFunction
                                 functionWithName:kCAMediaTimingFunctionDefault];
    transition.duration = 1.0;
    transition.type = kCATransitionFade;
    [nav.view.layer addAnimation:transition forKey:nil];
    
    //push new controller
    [nav popViewControllerAnimated:NO];
}

@end
