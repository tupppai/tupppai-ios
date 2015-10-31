//
//  ATOMLoginViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDLoginVC.h"
#import "ATOMLoginView.h"
#import "PIETabBarController.h"
#import "AppDelegate.h"
#import "ATOMUser.h"
#import "ATOMUserProfileViewModel.h"
#import "DDCreateProfileVC.h"

#import "DDInputPhoneFPVC.h"
@interface DDLoginVC ()
@property (nonatomic, strong) ATOMLoginView *loginView;
@end

@implementation DDLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    _loginView = [ATOMLoginView new];
    self.title = @"登录";
    self.view  = _loginView;

    [_loginView.loginButton addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.weiboLoginButton addTarget:self action:@selector(clickweiboLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.wechatLoginButton addTarget:self action:@selector(clickwechatLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.forgetPasswordButton addTarget:self action:@selector(clickForgetPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickLoginButton:(UIButton *)sender {
    if (![_loginView.mobileTextField.text isMobileNumber]) {
        [Util ShowTSMessageWarn:@"手机格式有误"];
    } else if (![_loginView.passwordTextField.text isPassword]) {
        [Util ShowTSMessageWarn:@"密码格式有误"];
    } else {
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_loginView.mobileTextField.text, @"phone", _loginView.passwordTextField.text, @"password",nil];
        [DDUserManager DDLogin:param withBlock:^(BOOL succeed) {
            if (succeed) {
                [self.navigationController setViewControllers:[NSArray array]];
                [AppDelegate APP].mainTabBarController = nil;
                [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTabBarController];
            }
        }];
    }
}

- (void)clickweiboLoginButton:(UIButton *)sender {
    [DDShareManager authorize:SSDKPlatformTypeSinaWeibo withBlock:^(NSDictionary *sourceData) {
        if (sourceData) {
            NSString* openID = sourceData[@"idstr"];
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:openID forKey:@"openid"];
            [DDUserManager DD3PartyAuth:param AndType:@"weibo" withBlock:^(bool isRegistered, NSString *info) {
                if (isRegistered) {
                    [Hud activity:@"" inView:self.view];
                    [self.navigationController setViewControllers:[NSArray array]];
                    [AppDelegate APP].mainTabBarController = nil;
                    [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTabBarController];
                } else {
                    [DDUserManager currentUser].signUpType = ATOMSignUpWeibo;
                    [DDUserManager currentUser].sourceData = sourceData;
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
                    DDCreateProfileVC *cpvc = [DDCreateProfileVC new];
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
    [DDShareManager authorize:SSDKPlatformTypeWechat withBlock:^(NSDictionary *sourceData) {
        if (sourceData) {
            NSString* openid = sourceData[@"openid"];
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:openid forKey:@"openid"];
            [DDUserManager DD3PartyAuth:param AndType:@"weixin" withBlock:^(bool isRegistered, NSString *info) {
                if (isRegistered) {
                    [Hud activity:@"" inView:self.view];
                    [self.navigationController setViewControllers:[NSArray array]];
                    [AppDelegate APP].mainTabBarController = nil;
                    [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTabBarController];
                } else {
                    [DDUserManager currentUser].signUpType = ATOMSignUpWechat;
                    [DDUserManager currentUser].sourceData = sourceData;
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
                    DDCreateProfileVC *cpvc = [DDCreateProfileVC new];
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
    DDInputPhoneFPVC* fpvc = [DDInputPhoneFPVC new];
    [self.navigationController pushViewController:fpvc animated:YES];
}



@end
