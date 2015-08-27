//
//  ATOMLaunchViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDLaunchVC.h"
#import "ATOMLaunchView.h"
#import "DDCreateProfileVC.h"
#import "DDLoginVC.h"
#import "ATOMLogin.h"
#import "AppDelegate.h"
#import "DDTabBarController.h"
#import "ATOMShareSDKModel.h"
#import "EAIntroView.h"
@interface DDLaunchVC ()

@property (nonatomic, strong) ATOMLaunchView *launchView;
@end

@implementation DDLaunchVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
    [ATOMShareSDKModel authorize:SSDKPlatformTypeWechat withBlock:^(NSDictionary *sourceData) {
        if (sourceData) {
            NSString* openid = sourceData[@"openid"];
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:openid forKey:@"openid"];
            [loginModel openIDAuth:param AndType:@"weixin" withBlock:^(bool isRegister, NSString *info, NSError *error) {
                if (isRegister) {
                    [self.navigationController setViewControllers:nil];
                    [AppDelegate APP].mainTabBarController = nil;
                    [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTabBarController];
                } else if (isRegister == NO) {
                    [DDUserModel currentUser].signUpType = ATOMSignUpWechat;
                    [DDUserModel currentUser].sourceData = sourceData;
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

- (void)clickOtherRegisterButton:(UIButton *)sender {

    [DDUserModel currentUser].signUpType = ATOMSignUpMobile;
    
    DDCreateProfileVC *cpvc = [DDCreateProfileVC new];
    [self.navigationController pushViewController:cpvc animated:YES];
}

- (void)clickLoginButton:(UIButton *)sender {
    DDLoginVC *lvc = [DDLoginVC new];
    [self.navigationController pushViewController:lvc animated:YES];
}
@end
