//
//  SkeweView.m
//  Presentation
//
//  Created by Nick Lockwood on 21/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "SkeweView.h"
#import <QuartzCore/QuartzCore.h>


@implementation SkeweView

- (void)awakeFromNib
{
    self.layer.transform = CATransform3DMakeRotation(M_PI/8, 0, 0.1, 1);
}

@end
