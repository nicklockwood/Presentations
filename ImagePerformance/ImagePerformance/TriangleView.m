//
//  TriangleView.m
//  ImagePerformance
//
//  Created by Nick Lockwood on 04/05/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "TriangleView.h"

@implementation TriangleView

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.bounds.size.width / 2, 0)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [path addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    [path closePath];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 3;
}

@end
