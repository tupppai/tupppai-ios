//
//  ATOMLoginViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMLoginViewController.h"
#import "ATOMLoginView.h"
#import "ATOMMainTabBarController.h"
#import "AppDelegate.h"

@interface ATOMLoginViewController ()

@property (nonatomic, strong) ATOMLoginView *loginView;

@end

@implementation ATOMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"登录";
    _loginView = [ATOMLoginView new];
    self.view = _loginView;
    [_loginView.loginButton addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.xlLoginButton addTarget:self action:@selector(clickXLLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.wxLoginButton addTarget:self action:@selector(clickWXLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.qqLoginButton addTarget:self action:@selector(clickQQLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.forgetPasswordButton addTarget:self action:@selector(clickForgetPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickLoginButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
    [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTarBarController];
}

- (void)clickXLLoginButton:(UIButton *)sender {
    
}

- (void)clickWXLoginButton:(UIButton *)sender {
    
}

- (void)clickQQLoginButton:(UIButton *)sender {
    
}

- (void)clickForgetPasswordButton:(UIButton *)sender {
    
}



@end
