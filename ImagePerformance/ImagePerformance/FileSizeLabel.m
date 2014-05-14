//
//  FileSizeLabel.m
//  ImagePerformance
//
//  Created by Nick Lockwood on 24/04/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "FileSizeLabel.h"

@implementation FileSizeLabel

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.imagePath];
    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:NULL];
    
    long long bytes = [dict fileSize];
    double size = bytes;
    NSString *unit = @"bytes";
    if (size > 1024 * 1024)
    {
        unit = @"MB";
        size /= (1024 * 1024);
    }
    else if (size > 1024)
    {
        unit = @"KB";
        size /= 1024;
    }
    
    self.text = [NSString stringWithFormat:@"%@: %.1f %@", [path pathExtension], size, unit];
}

@end
