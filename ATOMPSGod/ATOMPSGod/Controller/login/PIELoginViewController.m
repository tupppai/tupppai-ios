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
#import "PIEEntityUser.h"
#import "PIEUserProfileViewModel.h"
#import "DDCreateProfileVC.h"

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
    [self login:ATOMSignUpQQ];
}
- (void)tap2 {
    [self login:ATOMSignUpQQ];
}
- (void)tap3 {
    [self login:ATOMSignUpWechat];
}


- (void)login:(ATOMSignUpType)type {
    NSString* typeStr = @"error";
    SSDKPlatformType platformType = SSDKPlatformTypeAny;
    if (type == ATOMSignUpQQ) {
        typeStr = @"qq";
        platformType = SSDKPlatformTypeQQ;
    } else if (type == ATOMSignUpWechat) {
        typeStr = @"weixin";
        platformType = SSDKPlatformTypeWechat;
    } else if (type == ATOMSignUpWeibo) {
        typeStr = @"weibo";
        platformType = SSDKPlatformTypeSinaWeibo;
    } else if (type == ATOMSignUpMobile) {
        
    }
    [DDShareManager authorize2:platformType withBlock:^(SSDKUser *sdkUser) {
        if (sdkUser) {
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:sdkUser.uid forKey:@"openid"];
            
            [DDUserManager DD3PartyAuth:param AndType:typeStr withBlock:^(bool isRegistered, NSString *info) {
                if (isRegistered) {
                    [Hud activity:@"登录中"];
                    [self.navigationController setViewControllers:[NSArray array]];
                    [AppDelegate APP].mainTabBarController = nil;
                    [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTabBarController];
                    ;
                } else {
                    [DDUserManager currentUser].signUpType = type;
                    [DDUserManager currentUser].sdkUser = sdkUser;
                    DDCreateProfileVC *cpvc = [DDCreateProfileVC new];
                    [self.navigationController pushViewController:cpvc animated:YES];
                }
            }];
        }
    }];
}



- (void)toForgetPassword {
    DDInputPhoneFPVC* fpvc = [DDInputPhoneFPVC new];
    [self.navigationController pushViewController:fpvc animated:YES];
}


@end
