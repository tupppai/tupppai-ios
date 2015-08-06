//
//  ATOMMobileRegisterViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMobileRegisterViewController.h"
#import "ATOMMobileRegisterView.h"
#import "ATOMInputVerifyCodeViewController.h"
#import "ATOMGetMoblieCode.h"

@interface ATOMMobileRegisterViewController () <UITextFieldDelegate>

@property (nonatomic, strong) ATOMMobileRegisterView *mobileRegisterView;

@end

@implementation ATOMMobileRegisterViewController

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
        ATOMGetMoblieCode *getMobileCode = [ATOMGetMoblieCode new];
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_mobileRegisterView.mobileTextField.text, @"phone", nil];
        [getMobileCode GetMobileCode:param withBlock:^(NSString *verifyCode, NSError *error) {
            if (verifyCode && !error) {
                [ATOMCurrentUser currentUser].mobile = _mobileRegisterView.mobileTextField.text;
                [ATOMCurrentUser currentUser].password = [_mobileRegisterView.passwordTextField.text sha1];
//                NSLog(@"sha1 password%@",[ATOMCurrentUser currentUser].password);
                ATOMInputVerifyCodeViewController *ivcvc = [ATOMInputVerifyCodeViewController new];
                ivcvc.verifyCode = verifyCode;
                [self.navigationController pushViewController:ivcvc animated:YES];
            } else {
                
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
