//
//  CustomTransitionViewController.m
//  Transitions
//
//  Created by Nick Lockwood on 26/09/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "CustomTransitionViewController.h"


@interface CustomTransitionViewController () <UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning>

@end


@implementation CustomTransitionViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

//UINavigationControllerDelegate methods

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    //we return self as the <UIViewControllerAnimatedTransitioning> implementation in this case,
    //but the transition could easily be implemented as a different object to make it reusable
    return self;
}

//UIViewControllerAnimatedTransitioning methods

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //get source & destination view controller
    UIViewController *source = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *dest = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    //perform transition
    [UIView transitionFromView:source.view
                        toView:dest.view
                      duration:[self transitionDuration:transitionContext]
                       options:UIViewAnimationOptionTransitionCurlUp
                    completion:^(BOOL finished) {
        
                        //inform context that transition is finished
                        [transitionContext completeTransition:finished];
    }];
}

@end
