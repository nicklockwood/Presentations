//
//  ViewController.m
//  ImagePerformance
//
//  Created by Nick Lockwood on 17/03/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "iCarousel.h"


#define CAROUSEL_ENABLED 1


@interface UIView (Animation)

@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) CGSize offset;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) BOOL fadeIn;
@property (nonatomic, assign) BOOL fadeOut;

- (void)didAppear;

@end


@implementation UIView (Animation)

- (void)setDuration:(NSInteger)duration
{
    objc_setAssociatedObject(self, @selector(duration), @(duration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)duration
{
    return [objc_getAssociatedObject(self, @selector(duration)) integerValue];
}

- (void)setOffset:(CGSize)offset
{
    objc_setAssociatedObject(self, @selector(offset), NSStringFromCGSize(offset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)offset
{
    return CGSizeFromString(objc_getAssociatedObject(self, @selector(offset)));
}

- (void)setScale:(CGFloat)scale
{
    objc_setAssociatedObject(self, @selector(scale), @(scale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)scale
{
    return [objc_getAssociatedObject(self, @selector(scale)) floatValue];
}

- (void)setFadeIn:(BOOL)fadeIn
{
    objc_setAssociatedObject(self, @selector(fadeIn), @(fadeIn), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)fadeIn
{
    return [objc_getAssociatedObject(self, @selector(fadeIn)) boolValue];
}

- (void)setFadeOut:(BOOL)fadeOut
{
    objc_setAssociatedObject(self, @selector(fadeOut), @(fadeOut), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)fadeOut
{
    return [objc_getAssociatedObject(self, @selector(fadeOut)) boolValue];
}

- (void)didAppear
{
    //does nothing
}

@end


@interface SlideData : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) BOOL didAppearCalled;
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, assign) CGFloat red;
@property (nonatomic, assign) CGFloat green;
@property (nonatomic, assign) CGFloat blue;
@property (nonatomic, strong) UIImage *snapshot;
@end


@implementation SlideData

+ (instancetype)nibDataWithName:(NSString *)name
{
    SlideData *instance = [[self alloc] init];
    instance.name = name;
    
    //set color
    instance.red = (rand() / (double)INT32_MAX) * 0.25 + 0.75;
    instance.green = (rand() / (double)INT32_MAX) * 0.25 + 0.75;
    instance.blue = (rand() / (double)INT32_MAX) * 0.25 + 0.75;
    
    return instance;
}

- (void)loadNib
{
    if (!self.rootView)
    {
        self.rootView = [[[NSBundle mainBundle] loadNibNamed:self.name owner:nil options:nil] firstObject];
        self.rootView.autoresizingMask = UIViewAutoresizingNone;
        self.rootView.autoresizesSubviews = NO;
        if ([@[[UIColor whiteColor], [UIColor colorWithRed:1 green:1 blue:1 alpha:1]] containsObject:self.rootView.backgroundColor])
        {
            self.rootView.backgroundColor = nil;
        }
        self.duration = [self durationForView:self.rootView];
    }
}

- (void)unloadNib
{
    if (self.rootView)
    {
        [self.rootView removeFromSuperview];
        self.rootView = nil;
        self.didAppearCalled = NO;
    }
}

- (NSInteger)durationForView:(UIView *)view
{
    NSInteger duration = view.duration;
    for (UIView *subview in view.subviews)
    {
        duration = MAX(duration, [self durationForView:subview]);
    }
    return duration ?: self.rootView.duration ?: 1;
}

- (void)loadSnapshot
{
    if (!_snapshot)
    {
        BOOL loadRequired = !self.rootView;
        if (loadRequired) [self loadNib];
        
        [self didAppear];
        
        CGRect rect = CGRectMake(0, 0, 1024, 768);
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.25);
        [[UIColor whiteColor] setFill];
        CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
        [self.rootView drawViewHierarchyInRect:rect afterScreenUpdates:YES];
//        [self.rootView.layer renderInContext:UIGraphicsGetCurrentContext()]; //much faster than drawHierarchyInRect
        _snapshot = UIGraphicsGetImageFromCurrentImageContext();
        
        if (loadRequired) [self unloadNib];
    }
}

- (void)didAppear
{
    if (!self.didAppearCalled)
    {
        [self callDidAppearWithView:self.rootView];
        self.didAppearCalled = YES;
    }
}

- (void)callDidAppearWithView:(UIView *)view
{
    [view didAppear];
    for (UIView *subview in view.subviews)
    {
        [self callDidAppearWithView:subview];
    }
}

@end


@interface ViewController () <UIScrollViewDelegate, iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (nonatomic, strong) IBOutlet UIView *veil;
@property (nonatomic, strong) IBOutlet UIView *progress;
@property (nonatomic, strong) NSArray *nibData;
@property (nonatomic, assign) NSInteger lastIndex;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //disable idle timer
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    //ensure consistent background colors
    srand(999);
    
    //add gradient
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.startPoint = CGPointMake(0.5, 0);
    self.gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    [self.view.layer insertSublayer:self.gradientLayer below:self.scrollView.layer];
    
    //load slide list
    NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"nib" inDirectory:nil];
    paths = [paths valueForKeyPath:@"lastPathComponent.stringByDeletingPathExtension"];
    paths = [paths sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray *nibData = [NSMutableArray array];
    for (NSString *name in paths)
    {
        [nibData addObject:[SlideData nibDataWithName:name]];
    }
    self.nibData = nibData;
    self.scrollView.contentSize = CGSizeMake([nibData count] * 1024, 768);
    
#if CAROUSEL_ENABLED
    
    //load snapshots
    [self loadNextSnapshot:@0];
    
#else
    
    //skip carousel
    self.carousel.hidden = YES;
    [self finishedLoading];
    
#endif
    
}

- (void)finishedLoading
{
    //animate
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    [self.view.layer addAnimation:animation forKey:nil];
    
    //reload carousel
    [self.carousel reloadData];
    
    //load first slide
    [self loadUnloadSlides];
    [self updateBackgroundColorWithOffset:0];
    
    //hide veil
    self.veil.hidden = YES;
}

- (void)loadNextSnapshot:(NSNumber *)indexNumber
{
    NSInteger index = [indexNumber integerValue];
    if (index >= [self.nibData count])
    {
        [self finishedLoading];
    }
    else
    {
        [self.nibData[index] loadSnapshot];
        self.progress.frame = CGRectMake(1, 1, (self.progress.superview.bounds.size.width - 2) * index / ([self.nibData count] - 1), 12);
        [self performSelector:@selector(loadNextSnapshot:) withObject:@(index+ 1) afterDelay:0];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.gradientLayer.frame = self.view.bounds;
}

- (void)updateBackgroundColorWithOffset:(CGFloat)offset
{
    SlideData *data1 = self.nibData[MAX(0, (NSInteger)floor(offset))];
    SlideData *data2 = self.nibData[MIN([self.nibData count] - 1, (NSInteger)ceil(offset))];
    CGFloat ratio = offset - floor(offset);
    CGFloat red = data2.red * ratio + data1.red * (1 - ratio);
    CGFloat green = data2.green * ratio + data1.green * (1 - ratio);
    CGFloat blue = data2.blue * ratio + data1.blue * (1 - ratio);
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.gradientLayer.colors = @[(id)color.CGColor, (id)[UIColor whiteColor].CGColor];
    [CATransaction commit];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = self.scrollView.contentOffset.x / 1024;
    
    //update background color
    [self updateBackgroundColorWithOffset:offset];
    
    //adjust view positions
    NSInteger firstIndex = MAX(0, floor(offset));
    NSInteger lastIndex = MIN([self.nibData count] - 1, ceil(offset)) + 1;
    for (NSInteger i = 0; i < [self.nibData count]; i++)
    {
        SlideData *data = self.nibData[i];
        UIView *view = data.rootView;
        if (!view.superview && (i + data.duration > firstIndex && i < lastIndex))
        {
            [self loadUnloadSlides];
        }
        if (view.superview)
        {
            for (UIView *subview in view.subviews)
            {
                CGFloat relativeOffset = offset - i;
                CGAffineTransform transform = CGAffineTransformIdentity;
                
                //apply offset
                transform = CGAffineTransformTranslate(transform, MAX(0, MIN(1, relativeOffset)) * subview.offset.width,
                                                       MAX(0, MIN(1, relativeOffset)) * subview.offset.height);
                
                //apply lifetime
                CGFloat min = subview.fadeIn? -1: 0;
                CGFloat max = subview.fadeOut? 1: 0;
                transform = CGAffineTransformTranslate(transform, MAX(min, MIN([data durationForView:subview] - 1 + max, relativeOffset)) * 1024, 0);
                
                //apply fade
                CGFloat alpha = 1;
                if (subview.fadeIn && relativeOffset < 0)
                {
                    alpha = 1.0 + MAX(-1, relativeOffset);
                }
                else if (subview.fadeOut)
                {
                    alpha = 1.0 - (relativeOffset - [data durationForView:subview] + 1);
                }
                else
                {
                    alpha = 1.0 - (relativeOffset - [data durationForView:subview] + 1) * 2;
                    
                    //apply parallax effect
                    if (relativeOffset < 0)
                    {
                        transform = CGAffineTransformTranslate(transform, relativeOffset * -subview.center.x, 0);
                    }
                    else if (relativeOffset > [data durationForView:subview] - 1)
                    {
                        transform = CGAffineTransformTranslate(transform, (relativeOffset - [data durationForView:subview] + 1) * (subview.center.x - 1024), 0);
                    }
                }
                
                //apply scale
                CGFloat scale = 1.0 + MAX(0, MIN(1, relativeOffset)) * ((subview.scale ?: 1) - 1);
                transform = CGAffineTransformScale(transform, scale, scale);

                subview.alpha = alpha;
                subview.transform = transform;
            }
        }
    }
    
    [self hideMenu];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadUnloadSlides];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadUnloadSlides];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidScroll:scrollView];
    [self loadUnloadSlides];
}

- (void)loadUnloadSlides
{
    CGFloat offset = self.scrollView.contentOffset.x / 1024;
    NSInteger firstIndex = MAX(0, floor(offset));
    NSInteger lastIndex = MIN([self.nibData count] - 1, ceil(offset)) + 1;
    for (NSInteger i = 0; i < [self.nibData count]; i++)
    {
        SlideData *data = self.nibData[i];
        if ((!data.duration || i + data.duration >= firstIndex) && i <= lastIndex)
        {
            [data loadNib];
            data.rootView.frame = CGRectMake(i * 1024, 0, data.duration * 1024, 768);
            [self.scrollView addSubview:data.rootView];
        }
        else
        {
            [data unloadNib];
        }
    }
    
    //tell current slide to update
    if (firstIndex != self.lastIndex)
    {
        [self.nibData[firstIndex] didAppear];
        self.lastIndex = firstIndex;
    }
}

- (IBAction)showMenu
{
    [UIView animateWithDuration:0.4 animations:^{
        self.carousel.frame = CGRectMake(0, 668, 1024, 100);
    }];
}

- (IBAction)hideMenu
{
    if (self.carousel.frame.origin.y < 768)
    {
        [UIView animateWithDuration:0.4 animations:^{
            self.carousel.frame = CGRectMake(0, 768, 1024, 100);
        }];
    }
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.nibData count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIImageView *)view
{
    if (!view)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 75)];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.layer.borderWidth = 2;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
        label.font = [UIFont fontWithName:@"Gill Sans" size:20];
        label.textAlignment = NSTextAlignmentRight;
        [view addSubview:label];
    }
    view.image = [self.nibData[index] snapshot];
    ((UILabel *)view.subviews[0]).text = [NSString stringWithFormat:@"%@", @(index + 1)];
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1;
    }
    return value;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    [self.scrollView scrollRectToVisible:CGRectMake(index * 1024, 0, 1024, 768) animated:YES];
}

@end
