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
#import "ATOMLoginViewController.h"
#import "ATOMLogin.h"
#import "AppDelegate.h"
#import "ATOMMainTabBarController.h"
@interface ATOMLaunchViewController ()

@property (nonatomic, strong) ATOMLaunchView *launchView;
@end

@implementation ATOMLaunchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
    ATOMLogin *loginModel = [ATOMLogin new];
    [loginModel thirdPartyAuth:ShareTypeWeixiTimeline withBlock:^(NSDictionary *sourceData) {
        if (sourceData) {
            NSString* openid = sourceData[@"openid"];
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:openid forKey:@"openid"];
            [loginModel openIDAuth:param AndType:@"weixin" withBlock:^(bool isRegister, NSString *info, NSError *error) {
                if (isRegister) {
                    NSLog(@"已经注册微信账号");
                    [self.navigationController setViewControllers:nil];
                    [AppDelegate APP].mainTarBarController = nil;
                    [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTarBarController];
                } else if (isRegister == NO) {
                    NSLog(@"未注册微信账号");
                    [ATOMCurrentUser currentUser].signUpType = ATOMSignUpWeixin;
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
                    [self pushViewController:cpvc animated:YES];
                }
            }];
        }
        else {
            NSLog(@"获取不到第三平台的数据");
        }
    }];
}

- (void)clickOtherRegisterButton:(UIButton *)sender {
    [ATOMCurrentUser currentUser].signUpType = ATOMSignUpMobile;
    ATOMCreateProfileViewController *cpvc = [ATOMCreateProfileViewController new];
    [self pushViewController:cpvc animated:YES];
}

- (void)clickLoginButton:(UIButton *)sender {
    ATOMLoginViewController *lvc = [ATOMLoginViewController new];
    [self pushViewController:lvc animated:YES];
}
@end
