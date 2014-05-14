//
//  BodyLabel.m
//  ImagePerformance
//
//  Created by Nick Lockwood on 18/03/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "BodyLabel.h"

@implementation BodyLabel

- (void)awakeFromNib
{
    self.font = [UIFont fontWithName:@"Gill Sans" size:self.font.pointSize];
    if ([self.textColor isEqual:[UIColor blackColor]] || [self.textColor isEqual:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]])
    {
        self.textColor = [UIColor colorWithWhite:0 alpha:0.75];
    }
}

@end
