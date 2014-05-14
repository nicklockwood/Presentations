//
//  BulletLabel.m
//  ImagePerformance
//
//  Created by Nick Lockwood on 05/05/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "BulletLabel.h"

@implementation BulletLabel

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGFloat size = self.font.pointSize / 2;
    UIView *bullet = [[UIView alloc] initWithFrame:CGRectMake(-size - 20, 0, size, self.frame.size.height)];
    bullet.bounds = CGRectMake(0, 0, size, size);
    bullet.backgroundColor = self.textColor;
    [self addSubview:bullet];
    self.clipsToBounds = NO;
}

@end
