//
//  PIELoginViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/19/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIELoginViewController.h"
#import "PIETabBarController.h"
#import "AppDelegate.h"
#import "ATOMUser.h"
#import "ATOMUserProfileViewModel.h"
#import "DDCreateProfileVC.h"
#import "DDShareSDKManager.h"
#import "DDInputPhoneFPVC.h"

@interface PIELoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIImageView *socialView2;
@property (weak, nonatomic) IBOutlet UIImageView *socialView1;
@property (weak, nonatomic) IBOutlet UIImageView *socialView3;
@property (weak, nonatomic) IBOutlet UILabel *forgetLabel;
@property (weak, nonatomic) IBOutlet UILabel *socialTipLabel;

@end

@implementation PIELoginViewController
-(void)awakeFromNib {

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    _socialView1.userInteractionEnabled = YES;
    _socialView2.userInteractionEnabled = YES;
    _socialView3.userInteractionEnabled = YES;
    _loginLabel.userInteractionEnabled = YES;
    _forgetLabel.userInteractionEnabled = YES;
    _loginLabel.textColor = [UIColor colorWithHex:0x4A4A4A];


    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1)];
    UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2)];
    UITapGestureRecognizer* tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap3)];
    UITapGestureRecognizer* tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLogin)];
    UITapGestureRecognizer* tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toForgetPassword)];

    [_socialView1 addGestureRecognizer:tap1];
    [_socialView2 addGestureRecognizer:tap2];
    [_socialView3 addGestureRecognizer:tap3];
    [_loginLabel addGestureRecognizer:tap4];
    [_forgetLabel addGestureRecognizer:tap5];

    _loginLabel.backgroundColor = [UIColor colorWithHex:0XFFEF06];
    _loginLabel.layer.cornerRadius = 18;
    _loginLabel.clipsToBounds = YES;
}

- (void)tapLogin {
    if (![_phoneTextfield.text isMobileNumber]) {
        [Util ShowTSMessageWarn:@"手机格式有误"];
    } else if (![_passwordTextfield.text isPassword]) {
        [Util ShowTSMessageWarn:@"密码格式有误"];
    } else {
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_phoneTextfield.text, @"phone", _passwordTextfield.text, @"password",nil];
        [DDUserManager DDLogin:param withBlock:^(BOOL succeed) {
            if (succeed) {
                [self.navigationController setViewControllers:[NSArray array]];
                [AppDelegate APP].mainTabBarController = nil;
                [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTabBarController];
                ;
            }
        }];
    }
}
- (void)tap1 {
    
    [Util warningBetaTest];

//    [DDShareManager authorize2:SSDKPlatformTypeQQ withBlock:^(SSDKUser *sdkUser) {
//        NSString* openID = sdkUser.uid;
//        NSMutableDictionary* param = [NSMutableDictionary new];
//        [param setObject:openID forKey:@"openid"];
//        [DDUserManager DD3PartyAuth:param AndType:@"qq" withBlock:^(bool isRegistered, NSString *info) {
//            if (isRegistered) {
//                [Hud activity:@"" inView:self.view];
//                [self.navigationController setViewControllers:[NSArray array]];
//                [AppDelegate APP].mainTabBarController = nil;
//                [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTabBarController];
//                ;
//            } else {
//                [DDUserManager currentUser].signUpType = ATOMSignUpWeibo;
//                [DDUserManager currentUser].sourceData = sdkUser.rawData;
//                ATOMUserProfileViewModel* ipvm = [ATOMUserProfileViewModel new];
//                ipvm.nickName = sdkUser.nickname;
//                //                    ipvm.province = sourceData[@"province"];
//                //                    ipvm.city = sourceData[@"city"];
//                ipvm.avatarURL = sdkUser.icon;
//                if (sdkUser.gender == 1) {
//                    ipvm.gender = @"女";
//                } else {
//                    ipvm.gender = @"男";
//                }
//                DDCreateProfileVC *cpvc = [DDCreateProfileVC new];
//                cpvc.userProfileViewModel = ipvm;
//                [self.navigationController pushViewController:cpvc animated:YES];
//            }
//            
//        }];
//    }];
}
- (void)tap2 {
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
                    ;
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
- (void)tap3 {
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
                    ;
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





- (void)toForgetPassword {
    DDInputPhoneFPVC* fpvc = [DDInputPhoneFPVC new];
    [self.navigationController pushViewController:fpvc animated:YES];
}


@end
