//
//  UITransitionView.m
//  Presentation
//
//  Created by Nick Lockwood on 05/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "UIKitTransitionsView.h"

@interface UIKitTransitionsView ()

@property (nonatomic, weak) IBOutlet UILabel *nextTransitionLabel;
@property (nonatomic, strong) NSArray *transitions;
@property (nonatomic, strong) NSArray *transitionNames;
@property (nonatomic, assign) UIViewAnimationOptions currentTransition;

@end

@implementation UIKitTransitionsView

- (void)awakeFromNib
{
    self.transitions = @[@(UIViewAnimationOptionTransitionCrossDissolve),
                         @(UIViewAnimationOptionTransitionCurlDown),
                         @(UIViewAnimationOptionTransitionCurlUp),
                         @(UIViewAnimationOptionTransitionFlipFromBottom),
                         @(UIViewAnimationOptionTransitionFlipFromLeft),
                         @(UIViewAnimationOptionTransitionFlipFromRight),
                         @(UIViewAnimationOptionTransitionFlipFromTop)];
    
    self.transitionNames = @[@"CrossDissolve",
                             @"CurlDown",
                             @"CurlUp",
                             @"FlipFromBottom",
                             @"FlipFromLeft",
                             @"FlipFromRight",
                             @"FlipFromTop"];
    
    [self randomizeBackgroundColor];
    self.currentTransition = UIViewAnimationOptionTransitionCrossDissolve;
    NSInteger index = [self.transitions indexOfObject:@(self.currentTransition)];
    self.nextTransitionLabel.text = self.transitionNames[index];
}

- (void)randomizeBackgroundColor
{
    //randomize the layer background color
    self.backgroundColor = [UIColor colorWithRed:drand48()*0.5
                                           green:drand48()*0.5
                                            blue:drand48()*0.5
                                           alpha:1.0];
}

- (void)updateText
{
    //cycle to next transition
    NSInteger index = [self.transitions indexOfObject:@(self.currentTransition)];
    index = (index + 1) % [self.transitions count];
    self.currentTransition = [self.transitions[index] integerValue];
    
    //update label
    self.nextTransitionLabel.text = self.transitionNames[index];
}

- (IBAction)transition
{
    //perform transition
    [UIView transitionWithView:self
                      duration:0.5
                       options:self.currentTransition
                    animations:NULL
                    completion:NULL];

    //update view
    [self randomizeBackgroundColor];
    [self updateText];
}

@end
