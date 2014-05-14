//
//  BarView.m
//  ImagePerformance
//
//  Created by Nick Lockwood on 29/03/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "LoadingBar.h"


const CGFloat LabelSpacing = 10;


@interface LoadingBar ()

@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIView *firstDrawView;
@property (nonatomic, strong) UIView *secondDrawView;

@property (nonatomic, assign) NSTimeInterval timeScale;
@property (nonatomic, assign) NSTimeInterval loadTime;
@property (nonatomic, assign) NSTimeInterval firstDraw;
@property (nonatomic, assign) NSTimeInterval secondDraw;

@property (nonatomic, strong) UILabel *loadTimeLabel;
@property (nonatomic, strong) UILabel *firstDrawLabel;
@property (nonatomic, strong) UILabel *secondDrawLabel;
@property (nonatomic, strong) UILabel *totalTimeLabel;

@end


@implementation LoadingBar

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setUp];
    }
    return self;
}

- (void)setImageDetailsLabel:(UILabel *)imageDetailsLabel
{
    _imageDetailsLabel = imageDetailsLabel;
    if (!self.detailsFormat) self.detailsFormat = imageDetailsLabel.text;
    imageDetailsLabel.text = nil;
}

- (void)setUp
{
    self.backgroundColor = [UIColor clearColor];
    
    _secondDrawView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
    _secondDrawView.backgroundColor = [UIColor redColor];
    [self addSubview:_secondDrawView];
    
    _firstDrawView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
    _firstDrawView.backgroundColor = [UIColor greenColor];
    [self addSubview:_firstDrawView];
    
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
    _loadingView.backgroundColor = [UIColor blueColor];
    [self addSubview:_loadingView];
    
    _loadTimeLabel = [self defaultLabel];
    _firstDrawLabel = [self defaultLabel];
    _secondDrawLabel = [self defaultLabel];
    _totalTimeLabel = [self defaultLabel];
    
    _timeScale = 1;
    self.clipsToBounds = NO;
    [self setNeedsLayout];
}

- (UILabel *)defaultLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"Gill Sans" size:20];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    [self addSubview:label];
    return label;
}

- (NSString *)timeString:(NSTimeInterval)time
{
    if (time < 0.000001)
    {
        return @"";
    }
    else if (time > 1)
    {
        return [NSString stringWithFormat:@"%.2fs", time];
    }
    else if (time > 1.0/1000)
    {
        return [NSString stringWithFormat:@"%.0fms", time * 1000];
    }
    else
    {
        return [NSString stringWithFormat:@"%.0fµs", time * 1000000];
    }
}

- (void)setLabel:(UILabel *)label withTime:(NSTimeInterval)time offset:(CGFloat)offset
{
    label.text = [self timeString:time];
    CGSize size = [label sizeThatFits:self.bounds.size];
    CGRect frame;
    
    if (self.bounds.size.width < self.bounds.size.height)
    {
        //vertical
        frame = CGRectIntegral(CGRectMake(self.frame.size.width + LabelSpacing, self.frame.size.height * (1.0 - offset), size.width, size.height));
    }
    else
    {
        //horizontal
        frame = CGRectIntegral(CGRectMake(self.frame.size.width * offset - size.width, self.frame.size.height + LabelSpacing, size.width, size.height));
        
        if (time/self.timeScale * self.frame.size.width < size.width)
        {
            //top align
            frame.origin.y = - size.height - LabelSpacing;
        }
    }
    
    if (label.superview != self)
    {
        frame = [self convertRect:frame fromView:label.superview];
    }
    
    label.frame = frame;
}

- (void)layoutSubviews
{
    CGFloat loadTime = self.loadTime / self.timeScale;
    CGFloat firstDraw = loadTime + self.firstDraw / self.timeScale;
    CGFloat secondDraw = firstDraw + self.secondDraw / self.timeScale;

    if (!self.timeScale)
    {
        loadTime = firstDraw = secondDraw = 0;
    }
    
    self.loadTimeLabel.hidden = self.loadingView.hidden = !self.loadTime;
    self.firstDrawLabel.hidden = self.firstDrawView.hidden = !self.firstDraw;
    self.secondDrawLabel.hidden = self.secondDrawView.hidden = !self.secondDraw;
    self.totalTimeLabel.hidden = !self.firstDraw;
    
    NSString *total = [self timeString:self.loadTime + self.firstDraw + self.secondDraw];
    self.totalTimeLabel.text = [total length]? [@"Total: " stringByAppendingString:total]: @"";
    [self.totalTimeLabel sizeToFit];
    
    UIView *lastView = self.secondDrawView;
    if (!self.secondDraw) lastView = self.firstDrawView;
    
    if (self.bounds.size.width < self.bounds.size.height)
    {
        //vertical
        self.loadingView.frame = CGRectMake(0, floor(self.frame.size.height * (1.0 - loadTime)), self.frame.size.width, ceil(self.frame.size.height * loadTime));
        self.firstDrawView.frame = CGRectMake(0, floor(self.frame.size.height * (1.0 - firstDraw)), self.frame.size.width, ceil(self.frame.size.height * firstDraw));
        self.secondDrawView.frame = CGRectMake(0, floor(self.frame.size.height * (1.0 - secondDraw)), self.frame.size.width, ceil(self.frame.size.height * secondDraw));
        self.totalTimeLabel.center = CGPointMake(lastView.center.x, lastView.frame.origin.y - 10 - self.totalTimeLabel.frame.size.height/2);
    }
    else
    {
        //horizontal
        self.secondDrawView.frame = CGRectMake(0, 0, self.frame.size.width * secondDraw, self.frame.size.height);
        self.firstDrawView.frame = CGRectMake(0, 0, self.frame.size.width * firstDraw, self.frame.size.height);
        self.loadingView.frame = CGRectMake(0, 0, self.frame.size.width * loadTime, self.frame.size.height);
        self.totalTimeLabel.center = CGPointMake(lastView.frame.origin.x + lastView.frame.size.width + 10 + self.totalTimeLabel.frame.size.width / 2, lastView.center.y);
    }
    
    [self setLabel:self.loadTimeLabel withTime:self.loadTime offset:loadTime];
    [self setLabel:self.firstDrawLabel withTime:self.firstDraw offset:firstDraw];
    [self setLabel:self.secondDrawLabel withTime:self.secondDraw offset:secondDraw];
    
    CGRect frame = self.firstDrawLabel.frame;
    if (self.bounds.size.width < self.bounds.size.height)
    {
        //left align
        frame.origin.x = - frame.size.width - LabelSpacing;
        self.firstDrawLabel.frame = frame;
    }
    else
    {
        //top align
        frame.origin.y = - frame.size.height - LabelSpacing;
        self.firstDrawLabel.frame = frame;
    }
}

- (void)setScale:(NSTimeInterval)scale
        animated:(BOOL)animated
{
    [self setScale:scale loadTime:self.loadTime firstDraw:self.firstDraw secondDraw:self.secondDraw animated:animated];
}

- (void)setScale:(NSTimeInterval)scale
        loadTime:(NSTimeInterval)loadTime
       firstDraw:(NSTimeInterval)firstDraw
      secondDraw:(NSTimeInterval)secondDraw
        animated:(BOOL)animated
{
    self.timeScale = scale;
    self.loadTime = loadTime;
    self.firstDraw = firstDraw;
    self.secondDraw = secondDraw;
    
    if (animated)
    {
        [UIView animateWithDuration:0.5 animations:^{
            
            [self setNeedsLayout];
            [self layoutIfNeeded];
        }];
    }
    else
    {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

@end
