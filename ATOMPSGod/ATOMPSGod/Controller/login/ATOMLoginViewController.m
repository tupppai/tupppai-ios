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
#import "ATOMLogin.h"
#import "ATOMUser.h"

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
//    ATOMLogin *login = [ATOMLogin new];
//    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_loginView.mobileTextField.text, @"phone", _loginView.passwordTextField.text, @"password", nil];
//    [SVProgressHUD showWithStatus:@"正在登录中..."];
//    [login Login:param AndType:@"mobile" withBlock:^(ATOMUser *user, NSError *error) {
//        [SVProgressHUD dismiss];
//        if (!error) {
//            if (![login isExistUser:user]) {
//                [login saveUserInDB:user];
//            }
//            [self.navigationController popViewControllerAnimated:NO];
//            [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTarBarController];
//        } else {
//            NSLog(@"error");
//        }
//    }];
    [self.navigationController popViewControllerAnimated:NO];
    [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTarBarController];
}

- (void)clickXLLoginButton:(UIButton *)sender {
    
}

- (void)clickWXLoginButton:(UIButton *)sender {
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (result) {
//            PFQuery *query = [PFQuery querywith]
        }
    }];
}

- (void)clickQQLoginButton:(UIButton *)sender {
    
}

- (void)clickForgetPasswordButton:(UIButton *)sender {
    
}



@end
