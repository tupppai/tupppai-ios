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
#import "ATOMUserProfileViewModel.h"
#import "ATOMCreateProfileViewController.h"
#import "ATOMShareSDKModel.h"
#import "ATOMForgetPasswordViewController.h"
@interface ATOMLoginViewController ()
@property (nonatomic, strong) ATOMLoginView *loginView;
@end

@implementation ATOMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
//    self.navigationController.navigationBarHidden = YES;
}

- (void)createUI {
    _loginView = [ATOMLoginView new];
    self.title = @"登录";
    self.view  = _loginView;
    [_loginView.backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.loginButton addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.weiboLoginButton addTarget:self action:@selector(clickweiboLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.wechatLoginButton addTarget:self action:@selector(clickwechatLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.forgetPasswordButton addTarget:self action:@selector(clickForgetPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)clickBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickLoginButton:(UIButton *)sender {
    if (![_loginView.mobileTextField.text isMobileNumber]) {
        [Util ShowTSMessageWarn:@"手机格式有误"];
    } else if (![_loginView.passwordTextField.text isPassword]) {
        [Util ShowTSMessageWarn:@"密码格式有误"];
    } else {
        ATOMLogin *loginModel = [ATOMLogin new];
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_loginView.mobileTextField.text, @"phone", _loginView.passwordTextField.text, @"password",nil];
        [loginModel Login:param withBlock:^(BOOL succeed) {
            if (succeed) {
                [self.navigationController setViewControllers:nil];
                [AppDelegate APP].mainTabBarController = nil;
                [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTabBarController];
            }
        }];
    }
}

- (void)clickweiboLoginButton:(UIButton *)sender {
    
    ATOMLogin *loginModel = [ATOMLogin new];
    [ATOMShareSDKModel getUserInfo:SSDKPlatformTypeSinaWeibo withBlock:^(NSDictionary *sourceData) {
        if (sourceData) {
            NSString* openID = sourceData[@"idstr"];
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:openID forKey:@"openid"];
            [loginModel openIDAuth:param AndType:@"weibo" withBlock:^(bool isRegister, NSString *info, NSError *error) {
                if (isRegister) {
                    NSLog(@"微博登录成功");
                    [self.navigationController setViewControllers:nil];
                    [AppDelegate APP].mainTabBarController = nil;
                    [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTabBarController];
                } else if (isRegister == NO) {
                    NSLog(@"未注册微博账号");
                    [ATOMCurrentUser currentUser].signUpType = ATOMSignUpWeibo;
                    [ATOMCurrentUser currentUser].sourceData = sourceData;
                    ATOMUserProfileViewModel* ipvm = [ATOMUserProfileViewModel new];
                    ipvm.nickName = sourceData[@"name"];
                    ipvm.province = sourceData[@"province"];
                    ipvm.city = sourceData[@"city"];
                    ipvm.avatarURL = sourceData[@"avatar_large"];
                    if ([(NSString*)sourceData[@"gender"] isEqualToString:@"m"]) {
                        ipvm.gender = @"男";
                    } else {
                        ipvm.gender = @"女";
                    }
                    ATOMCreateProfileViewController *cpvc = [ATOMCreateProfileViewController new];
                    cpvc.userProfileViewModel = ipvm;
                    [self.navigationController pushViewController:cpvc animated:YES];
                }
            }];
        }
        else {
            NSLog(@"获取不到第三平台的数据");
        }
    }];

}
- (void)clickwechatLoginButton:(UIButton *)sender {
    ATOMLogin *loginModel = [ATOMLogin new];
    [ATOMShareSDKModel getUserInfo:SSDKPlatformTypeWechat withBlock:^(NSDictionary *sourceData) {
        if (sourceData) {
            NSString* openid = sourceData[@"openid"];
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:openid forKey:@"openid"];
            [loginModel openIDAuth:param AndType:@"weixin" withBlock:^(bool isRegister, NSString *info, NSError *error) {
                if (isRegister) {
                    NSLog(@"微信登录成功");
                    [self.navigationController setViewControllers:nil];
                    [AppDelegate APP].mainTabBarController = nil;
                    [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTabBarController];
                } else if (isRegister == NO) {
                    NSLog(@"未注册微信账号");
                    [ATOMCurrentUser currentUser].signUpType = ATOMSignUpWechat;
                    [ATOMCurrentUser currentUser].sourceData = sourceData;
                    ATOMUserProfileViewModel* ipvm = [ATOMUserProfileViewModel new];
                    ipvm.nickName = sourceData[@"nickname"];
                    ipvm.province = sourceData[@"province"];
                    ipvm.city = sourceData[@"city"];
                    ipvm.avatarURL = sourceData[@"headimgurl"];
                    if ((BOOL)sourceData[@"sex"] == YES) {
                        ipvm.gender = @"男";
                    } else {
                        ipvm.gender = @"女";
                    }
                    ATOMCreateProfileViewController *cpvc = [ATOMCreateProfileViewController new];
                    cpvc.userProfileViewModel = ipvm;
                    [self.navigationController pushViewController:cpvc animated:YES];
                }
            }];
        }
        else {
            NSLog(@"获取不到第三平台的数据");
        }
    }];
}

- (void)clickForgetPasswordButton:(UIButton *)sender {
    ATOMForgetPasswordViewController* fpvc = [ATOMForgetPasswordViewController new];
    [self.navigationController pushViewController:fpvc animated:YES];
}



@end
