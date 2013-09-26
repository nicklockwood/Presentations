//
//  SKTransitionsView.m
//  Transitions
//
//  Created by Nick Lockwood on 21/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "SKTransitionsView.h"


const NSTimeInterval duration = 0.5;


@interface SKTransitionsView ()

@property (nonatomic, weak) IBOutlet UILabel *nextTransitionLabel;
@property (nonatomic, strong) NSArray *transitions;
@property (nonatomic, strong) NSArray *transitionNames;
@property (nonatomic, assign) SKTransition *currentTransition;

@end


@implementation SKTransitionsView

- (void)awakeFromNib
{
    //set up scene
    SKScene *scene = [SKScene sceneWithSize:self.bounds.size];
    scene.backgroundColor = self.backgroundColor;
    [self presentScene:scene];
    
    self.transitions = @[[SKTransition crossFadeWithDuration:duration],
                         [SKTransition revealWithDirection:SKTransitionDirectionLeft duration:duration],
                         [SKTransition moveInWithDirection:SKTransitionDirectionLeft duration:duration],
                         [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:duration],
                         [SKTransition flipHorizontalWithDuration:duration],
                         [SKTransition flipVerticalWithDuration:duration],
                         [SKTransition fadeWithDuration:duration],
                         [SKTransition doorsOpenHorizontalWithDuration:duration],
                         [SKTransition doorsOpenVerticalWithDuration:duration],
                         [SKTransition doorsCloseHorizontalWithDuration:duration],
                         [SKTransition doorsCloseVerticalWithDuration:duration]];
    
    self.transitionNames = @[@"[SKTransition crossFadeWithDuration:duration]",
                             @"[SKTransition revealWithDirection:SKTransitionDirectionLeft duration:duration]",
                             @"[SKTransition moveInWithDirection:SKTransitionDirectionLeft duration:duration]",
                             @"[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:duration]",
                             @"[SKTransition flipHorizontalWithDuration:duration]",
                             @"[SKTransition flipVerticalWithDuration:duration]",
                             @"[SKTransition fadeWithDuration:duration]",
                             @"[SKTransition doorsOpenHorizontalWithDuration:duration]",
                             @"[SKTransition doorsOpenVerticalWithDuration:duration]",
                             @"[SKTransition doorsCloseHorizontalWithDuration:duration]",
                             @"[SKTransition doorsCloseVerticalWithDuration:duration]"];
    
    self.currentTransition = self.transitions[0];
    self.nextTransitionLabel.text = self.transitionNames[0];
}

- (IBAction)transition
{
    //create new scene
    SKScene *scene = [SKScene sceneWithSize:self.bounds.size];
    scene.backgroundColor = [UIColor colorWithRed:drand48()*0.75
                                            green:drand48()*0.75
                                             blue:drand48()*0.75
                                            alpha:1.0];
    
    //present scene
    [self presentScene:scene transition:self.currentTransition];
    
    //cycle to next transition
    NSInteger index = [self.transitions indexOfObject:self.currentTransition];
    index = (index + 1) % [self.transitions count];
    self.currentTransition = self.transitions[index];
    self.nextTransitionLabel.text = self.transitionNames[index];
}

@end
