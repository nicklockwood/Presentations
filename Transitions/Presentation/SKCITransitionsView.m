//
//  SKCITransitionsView.m
//  Transitions
//
//  Created by Nick Lockwood on 22/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "SKCITransitionsView.h"
#import <CoreImage/CoreImage.h>


@interface SKCITransitionsView ()

@property (nonatomic, weak) IBOutlet UILabel *nextTransitionLabel;
@property (nonatomic, strong) NSArray *filterNames;
@property (nonatomic, assign) NSString *currentFilterName;

@end


@implementation SKCITransitionsView

- (void)awakeFromNib
{
    //set up scene
    SKScene *scene = [SKScene sceneWithSize:self.bounds.size];
    scene.backgroundColor = self.backgroundColor;
    [self presentScene:scene];
    
    self.filterNames = [CIFilter filterNamesInCategory:kCICategoryTransition];
    self.currentFilterName = self.filterNames[0];
    self.nextTransitionLabel.text = self.currentFilterName;
}

- (IBAction)transition
{
    //create new scene
    SKScene *scene = [SKScene sceneWithSize:self.bounds.size];
    scene.backgroundColor = [UIColor colorWithRed:drand48()*0.75
                                            green:drand48()*0.75
                                             blue:drand48()*0.75
                                            alpha:1.0];
    
    //create transition
    CIFilter *filter = [CIFilter filterWithName:self.currentFilterName];
    SKTransition *transition = [SKTransition transitionWithCIFilter:filter duration:0.5];
    
    //present scene
    [self presentScene:scene transition:transition];
    
    //cycle to next filter
    NSInteger index = [self.filterNames indexOfObject:self.currentFilterName];
    index = (index + 1) % [self.filterNames count];
    self.currentFilterName = self.filterNames[index];
    self.nextTransitionLabel.text = self.filterNames[index];
}

@end
