//
//  CATransitionsView.m
//  Presentation
//
//  Created by Nick Lockwood on 10/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "CATransitionsView.h"
#import <QuartzCore/QuartzCore.h>

@interface CATransitionsView ()

@property (nonatomic, weak) IBOutlet UILabel *nextTransitionLabel;
@property (nonatomic, strong) NSArray *transitions;
@property (nonatomic, strong) NSArray *transitionNames;
@property (nonatomic, assign) NSString *currentTransition;

@end

@implementation CATransitionsView

- (void)awakeFromNib
{
    self.transitions = @[kCATransitionFade,
                         kCATransitionPush,
                         kCATransitionMoveIn,
                         kCATransitionReveal];
    
    self.transitionNames = @[@"kCATransitionFade",
                             @"kCATransitionPush",
                             @"kCATransitionMoveIn",
                             @"kCATransitionReveal"];
    
    [self randomizeBackgroundColor];
    self.currentTransition = kCATransitionFade;
    NSInteger index = [self.transitions indexOfObject:self.currentTransition];
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
    NSInteger index = [self.transitions indexOfObject:self.currentTransition];
    index = (index + 1) % [self.transitions count];
    self.currentTransition = self.transitions[index];
    
    //update label
    self.nextTransitionLabel.text = self.transitionNames[index];
}

- (IBAction)transition
{
    //perform transition
    CATransition *transition = [CATransition animation];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.duration = 0.5;
    transition.type = self.currentTransition;
    [self.layer addAnimation:transition forKey:nil];
    
    //update view
    [self randomizeBackgroundColor];
    [self updateText];
}

@end
