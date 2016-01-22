//
//  PIEChannelTutorialViewController.m
//  TUPAI
//
//  Created by huangwei on 16/1/22.
//  Copyright © 2016年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialViewController.h"
#import "PIEChannelViewModel.h"

@implementation PIEChannelTutorialViewController

#pragma mark - UI life cycles
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", self.currentChannelViewModel);
    
    [self setupSubViews];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNavBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}


#pragma mark - basic UI setup
- (void)setupNavBar
{
    
}

- (void)setupSubViews
{
    
}


@end
