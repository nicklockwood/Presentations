//
//  FadeInLabel.h
//  Presentation
//
//  Created by Nick Lockwood on 21/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FadeInLabel : UILabel

@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, copy) NSString *hyperlink;

@end
