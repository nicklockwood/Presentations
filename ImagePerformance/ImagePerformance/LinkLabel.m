//
//  LinkLabel.m
//  ImagePerformance
//
//  Created by Nick Lockwood on 13/05/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "LinkLabel.h"

@implementation LinkLabel

- (void)awakeFromNib
{
    self.font = [UIFont fontWithName:@"Menlo" size:self.font.pointSize];
    self.textColor = [UIColor blackColor];

    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openURL)]];
}

- (void)openURL
{
    NSURL *URL = [NSURL URLWithString:self.text];
    [[UIApplication sharedApplication] openURL:URL];
}

@end
