//
//  ATOMMobileRegisterViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDPhoneRegisterVC.h"
#import "ATOMMobileRegisterView.h"
#import "DDAuthcodeVC.h"

@interface DDPhoneRegisterVC () <UITextFieldDelegate>

@property (nonatomic, strong) ATOMMobileRegisterView *mobileRegisterView;

@end

@implementation DDPhoneRegisterVC

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    _mobileRegisterView = [ATOMMobileRegisterView new];
    self.view = _mobileRegisterView;
    _mobileRegisterView.mobileTextField.delegate = self;
    _mobileRegisterView.passwordTextField.delegate = self;
    
    [_mobileRegisterView.nextButton addTarget:self action:@selector(clickRightButtonItem) forControlEvents:UIControlEventTouchUpInside];
    [_mobileRegisterView.backButton addTarget:self action:@selector(clickLeftButtonItem) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Click Event
- (void)clickLeftButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickRightButtonItem {
    if ([self checkInputMessageSuccess]) {
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_mobileRegisterView.mobileTextField.text, @"phone", nil];
        [DDProfileService getAuthCode:param withBlock:^(NSString* authcode) {
            if (authcode) {
                [DDUserModel currentUser].mobile = _mobileRegisterView.mobileTextField.text;
                [DDUserModel currentUser].password = [_mobileRegisterView.passwordTextField.text sha1];
                DDAuthcodeVC *ivcvc = [DDAuthcodeVC new];
                ivcvc.verifyCode = authcode;
                [self.navigationController pushViewController:ivcvc animated:YES];
            }
            else {
                [Util ShowTSMessageError:@"无法获取到验证码"];
            }
        }];

    }
}

- (BOOL)checkInputMessageSuccess {
    BOOL flag = YES;
    NSString *mobileStr = _mobileRegisterView.mobileTextField.text;
    NSString *passwordStr = _mobileRegisterView.passwordTextField.text;
    if (![mobileStr isMobileNumber]) {
        flag = NO;
        [Util ShowTSMessageWarn:@"请输入正确的手机号"];
    } else if (![passwordStr isPassword]) {
        [Util ShowTSMessageWarn:@"密码必须由6~16的位的数字和字母组成"];
        flag = NO;
    }
    return flag;
}

#pragma UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}





@end
