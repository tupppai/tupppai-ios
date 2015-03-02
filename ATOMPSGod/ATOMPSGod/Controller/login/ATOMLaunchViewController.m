//
//  ATOMLaunchViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMLaunchViewController.h"
#import "ATOMLaunchView.h"
#import "ATOMCreateProfileViewController.h"

@interface ATOMLaunchViewController ()

@property (nonatomic, strong) ATOMLaunchView *launchView;

@end

@implementation ATOMLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)createUI {
    _launchView = [ATOMLaunchView new];
    self.view = _launchView;
    
    [_launchView.wxRegisterButton addTarget:self action:@selector(clickWXRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
    [_launchView.otherRegisterButton addTarget:self action:@selector(clickOtherRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
    [_launchView.loginButton addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickWXRegisterButton:(UIButton *)sender {
    
}

- (void)clickOtherRegisterButton:(UIButton *)sender {
    ATOMCreateProfileViewController *cpvc = [[ATOMCreateProfileViewController alloc] init];
    [self.navigationController pushViewController:cpvc animated:YES];
}

- (void)clickLoginButton:(UIButton *)sender {
    
}






@end
