//
//  ProjectsView.m
//  Presentation
//
//  Created by Nick Lockwood on 21/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "ProjectsView.h"
#import "FadeInLabel.h"


@implementation ProjectsView

- (void)awakeFromNib
{
    NSArray *projects = @[@"iCarousel",
                          @"OSNavigationController",
                          @"XMLDictionary",
                          @"FXLabel",
                          @"RotateView",
                          @"HRCoder",
                          @"LayerSprites",
                          @"SwipeView",
                          @"FXKeychain",
                          @"FXReachability",
                          @"iRate",
                          @"HTMLLabel",
                          @"FXJSON",
                          @"GLView",
                          @"RequestUtils",
                          @"StringCoding",
                          @"iVersion",
                          @"StandardPaths",
                          @"iConsole",
                          @"AutoCoding",
                          @"ArrayUtils",
                          @"AsyncImageView",
                          @"iNotify",
                          @"iPrompt",
                          @"FXParser",
                          @"JPNG",
                          @"FXPhotoEditView",
                          @"ViewUtils",
                          @"Base64",
                          @"NullSafe",
                          @"RequestQueue",
                          @"CustomPageControl",
                          @"NSOperationStack",
                          @"BaseModel",
                          @"FXPageControl",
                          @"ColorUtils",
                          @"CryptoCoding",
                          @"FXImageView",
                          @"ReflectionView",
                          @"GZIP",
                          @"MACAddress",
                          @"SoundManager",
                          @"WebContentView"];
    
    const int columns = 4;
    int rows = ceil((double)[projects count] / (double)columns);
    
    for (int i = 0; i < columns; i++)
    {
        for (int j = 0; j < rows; j++)
        {
            NSInteger index = i * rows + j;
            if (index < [projects count])
            {
                CGRect rect = CGRectZero;
                rect.size.width = self.bounds.size.width / columns;
                rect.size.height = self.bounds.size.height / rows;
                rect.origin.x = rect.size.width * i;
                rect.origin.y = rect.size.height * j;
                FadeInLabel *label = [[FadeInLabel alloc] initWithFrame:rect];
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.text = projects[index];
                label.hyperlink = [NSString stringWithFormat:@"http://github.com/nicklockwood/%@", label.text];
                [self addSubview:label];
            }
        }
    }
}

@end
