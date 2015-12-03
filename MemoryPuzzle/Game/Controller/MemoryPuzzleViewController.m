//
//  MemoryPuzzleViewController.m
//  MemoryPuzzle
//
//  Created by slyao on 14/12/29.
//  Copyright (c) 2014年 slyao. All rights reserved.
//

#import "MemoryPuzzleViewController.h"

#define PUZZLE_TOP_HEIGHT       300

@interface MemoryPuzzleViewController ()

@property (strong, nonatomic) UIImageView   *topImageView;

@end

@implementation MemoryPuzzleViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = RGBCOLOR(0xe1, 0xe1, 0xe1);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initCustomView];
}

- (void)initCustomView
{
    self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64, SCREEN_WIDTH - 20, PUZZLE_TOP_HEIGHT)];
    self.topImageView.layer.borderColor = [UIColor brownColor].CGColor;
    self.topImageView.layer.borderWidth = 1.0f;
    self.topImageView.layer.cornerRadius = 2.0f;
    self.topImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.topImageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
