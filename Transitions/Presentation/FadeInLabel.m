//
//  FadeInLabel.m
//  Presentation
//
//  Created by Nick Lockwood on 21/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "FadeInLabel.h"


@interface FadeInLabel () <UIAlertViewDelegate>

@property (nonatomic, assign) BOOL alreadyAnimated;

@end


@implementation FadeInLabel

- (void)awakeFromNib
{
    if (!_alreadyAnimated)
    {
        self.alreadyAnimated = YES;
        self.hidden = YES;
        
        __weak FadeInLabel *weakSelf = self;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delay * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            
            [UIView transitionWithView:weakSelf
                              duration:weakSelf.duration ?: 1.0
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:NULL
                            completion:NULL];
            
            weakSelf.hidden = NO;
        });
    }
    else
    {
        self.hidden = NO;
    }
}

- (void)setHyperlink:(NSString *)hyperlink
{
    _hyperlink = [hyperlink copy];
    self.userInteractionEnabled = (hyperlink != nil);
    for (UIGestureRecognizer *gesture in self.gestureRecognizers)
    {
        [self removeGestureRecognizer:gesture];
    }
    if (hyperlink)
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:gesture];
    }
}

- (void)tap
{
    [[[UIAlertView alloc] initWithTitle:@"Open URL?" message:[NSString stringWithFormat:@"Would you like to open the URL: %@?", self.hyperlink] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Open Safari", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.hyperlink]];
    }
}

@end
