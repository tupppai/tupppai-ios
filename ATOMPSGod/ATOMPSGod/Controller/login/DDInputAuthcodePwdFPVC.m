//
//  ATOMInputVerifyCodeAndPasswordViewController.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/5/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "DDInputAuthcodePwdFPVC.h"
#import "ATOMInputVerifyCodeAndPasswordView.h"
#import "DDBaseService.h"

@interface DDInputAuthcodePwdFPVC ()

@property (nonatomic, strong) ATOMInputVerifyCodeAndPasswordView *inputVerifyView;
@property (nonatomic, strong) NSTimer *verifyTimer;
@end

@implementation DDInputAuthcodePwdFPVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createVerifyTimer];
}
- (void)createUI {
    _inputVerifyView = [ATOMInputVerifyCodeAndPasswordView new];
    self.view = _inputVerifyView;
    [_inputVerifyView.sendVerifyCodeButton addTarget:self action:@selector(clickVerifyButton:) forControlEvents:UIControlEventTouchUpInside];
    [_inputVerifyView.verifyCodeTextField becomeFirstResponder];
    [_inputVerifyView.nextButton addTarget:self action:@selector(clickRightButtonItem) forControlEvents:UIControlEventTouchUpInside];
    [_inputVerifyView.backButton addTarget:self action:@selector(clickLeftButtonItem) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createVerifyTimer {
    
    _verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(runVerifyTimer) userInfo:nil repeats:YES];
    _inputVerifyView.sendVerifyCodeButton.userInteractionEnabled = NO;
}

- (void)runVerifyTimer {
    _inputVerifyView.lastSecond--;
    if (_inputVerifyView.lastSecond<=0) {
        [_verifyTimer invalidate];
        _verifyTimer = nil;
        _inputVerifyView.sendVerifyCodeButton.userInteractionEnabled = YES;
    }
}
- (void)clickVerifyButton:(UIButton *)sender {
    _inputVerifyView.sendVerifyCodeButton.userInteractionEnabled = NO;
    _inputVerifyView.lastSecond = 30;
    [self createVerifyTimer];
    [self updateAuthCode];
}

- (void)updateAuthCode {
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[DDUserManager currentUser].mobile, @"phone", nil];
    [DDService getAuthCode:param withBlock:^(NSString* authcode) {
        if (authcode) {
            self.verifyCode = authcode;
        }
        else {
            [Util ShowTSMessageError:@"无法获取到验证码"];
        }
    }];
}


- (void)clickRightButtonItem{
        if ([_inputVerifyView.verifyCodeTextField.text isEqualToString:_verifyCode]) {
            if ([_inputVerifyView.passwordTextField.text isPassword]) {
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:_inputVerifyView.passwordTextField.text forKey:@"new_pwd"];
            [param setObject:_phoneNumber forKey:@"phone"];
            
            [DDService resetPassword:param withBlock:^(BOOL success) {
                if (success) {
                    [Util ShowTSMessageSuccess:@"成功设置密码"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [Util ShowTSMessageError:@"操作失败"];
                }
            }];
            } else {
                [Util ShowTSMessageWarn:@"密码必须由6~16位的数字和字母组成"];
            }
        } else {
            [Util ShowTSMessageError:@"验证码有误"];
        }
    }

- (void)clickLeftButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_verifyTimer invalidate];
    _verifyTimer = nil;
}

@end

