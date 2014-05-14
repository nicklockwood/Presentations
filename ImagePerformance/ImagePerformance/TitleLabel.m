//
//  TitleLabel.m
//  ImagePerformance
//
//  Created by Nick Lockwood on 18/03/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "TitleLabel.h"

@implementation TitleLabel

- (void)awakeFromNib
{
    self.font = [UIFont fontWithName:@"Georgia" size:self.font.pointSize];
}

@end
