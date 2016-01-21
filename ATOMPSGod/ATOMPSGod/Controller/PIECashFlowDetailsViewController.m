//
//  PIECashFlowDetailsViewController.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/21/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIECashFlowDetailsViewController.h"

@interface PIECashFlowDetailsViewController ()

@end

@implementation PIECashFlowDetailsViewController

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - UI basic setup
- (void)setupNavBar
{
    self.navigationItem.title = @"零钱明细";
}


@end
