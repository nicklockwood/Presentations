//
//  Button.m
//  ImagePerformance
//
//  Created by Nick Lockwood on 09/04/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "Button.h"

@implementation Button

- (void)awakeFromNib
{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
