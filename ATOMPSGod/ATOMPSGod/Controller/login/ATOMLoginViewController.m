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
    [_loginView.weiboLoginButton addTarget:self action:@selector(clickweiboLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.wechatLoginButton addTarget:self action:@selector(clickwechatLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.forgetPasswordButton addTarget:self action:@selector(clickForgetPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickLoginButton:(UIButton *)sender {
    if (![_loginView.mobileTextField.text isMobileNumber]) {
        [Util TextHud:@"手机格式不正确"];
        NSLog(@"请输入正确的手机格式");
    }
    if (![_loginView.passwordTextField.text isPassword]) {
        NSLog(@"密码不能包含特殊字符");
    }
    
    ATOMLogin *loginModel = [ATOMLogin new];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_loginView.mobileTextField.text, @"phone", _loginView.passwordTextField.text, @"password",nil];
    [loginModel Login:param withBlock:^(NSDictionary *sourceData) {
        
    }];
//    //[SVProgressHUD showWithStatus:@"正在登录中..."];
//    [login Login:param AndType:@"mobile" withBlock:^(ATOMUser *user, NSError *error) {
//        ////[SVProgressHUD dismiss];
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
//    [self.navigationController popViewControllerAnimated:NO];
//    [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTarBarController];
}


- (void)clickweiboLoginButton:(UIButton *)sender {
    
//    [ATOMCurrentUser currentUser].signUpType = ATOMSignUpWeibo;
//    [ATOMCurrentUser currentUser].sourceData = sourceData;
    NSLog(@"clickweiboLoginButton");
    [ShareSDK getUserInfoWithType:ShareTypeTencentWeibo
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
     {
         NSLog(@"result %d, userInfo %@,error %@",result,userInfo,error);

         if (result)
         {
             PFQuery *query = [PFQuery queryWithClassName:@"UserInfo"];
             [query whereKey:@"uid" equalTo:[userInfo uid]];
             [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
              {

                  if ([objects count] == 0)
                  {
                      PFObject *newUser = [PFObject objectWithClassName:@"UserInfo"];
                      [newUser setObject:[userInfo uid] forKey:@"uid"];
                      [newUser setObject:[userInfo nickname] forKey:@"name"];
                      [newUser setObject:[userInfo profileImage] forKey:@"icon"];
                      [newUser saveInBackground];
                      UIAlertView *alertView = [[UIAlertView alloc]
                                                initWithTitle:@"Hello"
                                                message:@"欢迎注册"
                                                delegate:nil
                                                cancelButtonTitle:@"知道了"
                                                otherButtonTitles: nil];
                      [alertView show];
                  }
                  else
                  {
                      UIAlertView *alertView = [[UIAlertView alloc]                                 initWithTitle:@"Hello"
                                                                                                          message:@"欢迎回来"
                                                                                                         delegate:nil
                                                                                                cancelButtonTitle:@"知道了"
                                                                                                otherButtonTitles:nil];
                      [alertView show];
                  }
              }];
             
             
         }
         
     }];
}
- (void)clickwechatLoginButton:(UIButton *)sender {
    ATOMLogin *loginModel = [ATOMLogin new];
    [loginModel thirdPartyAuth:ShareTypeWeixiTimeline withBlock:^(NSDictionary *sourceData) {
        if (sourceData) {
            NSString* openid = sourceData[@"openid"];
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:openid forKey:@"openid"];
            [loginModel openIDAuth:param AndType:@"weixin" withBlock:^(bool isRegister, NSString *info, NSError *error) {
                if (isRegister) {
                    NSLog(@"登录成功");
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

- (void)clickQQLoginButton:(UIButton *)sender {
    
}

- (void)clickForgetPasswordButton:(UIButton *)sender {
    
}



@end
