//
//  BaseViewController.m
//  Presentation
//
//  Created by Nick Lockwood on 03/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "BaseViewController.h"


static UIImageView *arrowView = nil;


@interface BaseViewController ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) UIStoryboardSegue *popSegue;

@end


@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //add backward swipe gesture
    UISwipeGestureRecognizer *swipeBack = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    swipeBack.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeBack];
    
    //add forward swipe gesture
    UISwipeGestureRecognizer *swipeNext = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goForward)];
    swipeNext.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeNext];
    
    //apply consistent style and position to heading
    self.titleLabel.font = [UIFont systemFontOfSize:30];
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.view.bounds.size.width / 2, 60);
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)goBack
{
    [arrowView removeFromSuperview];
    arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backward"]];
    arrowView.alpha = 0.5;
    arrowView.center = CGPointMake(100, 384);
    [self.navigationController.view addSubview:arrowView];
    [UIView animateWithDuration:1 animations:^{
        arrowView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) [arrowView removeFromSuperview];
    }];
    
    if (self.popSegue)
    {
        [self.popSegue perform];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)goForward
{
    [arrowView removeFromSuperview];
    arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forward"]];
    arrowView.alpha = 0.5;
    arrowView.center = CGPointMake(924, 384);
    [self.navigationController.view addSubview:arrowView];
    [UIView animateWithDuration:1 animations:^{
        arrowView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) [arrowView removeFromSuperview];
    }];
    
    @try
    {
        [self performSegueWithIdentifier:@"next" sender:self];
    }
    @catch (NSException *exception)
    {
        [arrowView removeFromSuperview];
        NSLog(@"Exception: %@", exception);
        //duh! that was the last slide
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //set the pop segue automatically (if it exists) by using magic
    NSString *segueName = NSStringFromClass([segue class]);
    NSString *popSegueName = [segueName stringByReplacingOccurrencesOfString:@"Push" withString:@"Pop"];
    UIStoryboardSegue *popSegue = [[NSClassFromString(popSegueName) alloc] initWithIdentifier:nil
                                                                                       source:segue.destinationViewController
                                                                                  destination:self];
    ((BaseViewController *)segue.destinationViewController).popSegue = popSegue;
}

@end
