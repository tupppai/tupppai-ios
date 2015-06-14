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
    [_loginView.weiboLoginButton addTarget:self action:@selector(clickweiboLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.wechatLoginButton addTarget:self action:@selector(clickwechatLoginButton:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)clickweiboLoginButton:(UIButton *)sender {
    
}

- (void)clickwechatLoginButton:(UIButton *)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (result) {
            PFQuery *query = [PFQuery queryWithClassName:@"UserInfo"];
            [query whereKey:@"uid" equalTo:[userInfo uid]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if ([objects count] == 0) {
                    PFObject *newUser = [PFObject objectWithClassName:@"UserInfo"];
                    [newUser setObject:[userInfo uid] forKey:@"uid"];
                    [newUser setObject:[userInfo nickname] forKey:@"name"];
                    [newUser setObject:[userInfo profileImage] forKey:@"icon"];
                    [newUser saveInBackground];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"欢迎注册" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alertView show];
                } else {
                    [SVProgressHUD showWithStatus:@"微信登陆成功" maskType:SVProgressHUDMaskTypeNone];
                    [self.navigationController popViewControllerAnimated:NO];
                    [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTarBarController];
                    [SVProgressHUD dismiss];
                }
            }];
        } else {
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)clickQQLoginButton:(UIButton *)sender {
    
}

- (void)clickForgetPasswordButton:(UIButton *)sender {
    
}



@end
