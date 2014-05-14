//
//  ImagePickerView.m
//  ImagePerformance
//
//  Created by Nick Lockwood on 07/04/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "ImagePickerView.h"


@interface ImagePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;

@end


static NSArray *_imagePaths = nil;
static NSArray *_extensions = nil;


@implementation ImagePickerView

+ (void)load
{
    [self performSelectorOnMainThread:@selector(loadPaths) withObject:nil waitUntilDone:NO];
}

+ (void)loadPaths
{
    //get paths
    NSString *imagesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Images"];
    NSMutableArray *imagePaths = [NSMutableArray array];
    for (NSString *path in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:imagesPath error:NULL])
    {
        NSString *fullPath = [[@"Images" stringByAppendingPathComponent:path] stringByDeletingPathExtension];
        if (![imagePaths containsObject:fullPath])
        {
            [imagePaths addObject:fullPath];
        }
    }
    _imagePaths = imagePaths;
    _extensions = @[@"png", @"cgbi", @"jpg", @"jpf"];
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
}

- (void)didAppear
{
    self.pickerView = [[UIPickerView alloc] initWithFrame:self.bounds];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self addSubview:self.pickerView];
    
    [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.hideExtensions? 1: 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [(component == 0)? _imagePaths: _extensions count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [((component == 0)? _imagePaths: _extensions)[row] lastPathComponent];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger index0 = [pickerView selectedRowInComponent:0];
    NSInteger index1 = self.hideExtensions? 0: [pickerView selectedRowInComponent:1];
    NSString *extension = self.hideExtensions? @"": _extensions[index1];
    NSString *path = [_imagePaths[index0] stringByAppendingPathExtension:extension];
    [self.delegate setImagePath:path];
}

@end
