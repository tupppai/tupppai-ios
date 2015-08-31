//
//  ATOMInputVerifyCode.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDAuthcodeVC.h"
#import "ATOMInputVerifyCodeView.h"
#import "AppDelegate.h"
#import "DDTabBarController.h"

@interface DDAuthcodeVC ()

@property (nonatomic, strong) ATOMInputVerifyCodeView *inputVerifyView;
@property (nonatomic, strong) NSTimer *verifyTimer;
@end

@implementation DDAuthcodeVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createVerifyTimer];
}

- (void)createUI {
    _inputVerifyView = [ATOMInputVerifyCodeView new];
    self.view = _inputVerifyView;
    [_inputVerifyView.sendVerifyCodeButton addTarget:self action:@selector(clickVerifyButton:) forControlEvents:UIControlEventTouchUpInside];
    [_inputVerifyView.verifyCodeTextField becomeFirstResponder];
    [_inputVerifyView.nextButton addTarget:self action:@selector(clickRightButtonItem) forControlEvents:UIControlEventTouchUpInside];
    [_inputVerifyView.backButton addTarget:self action:@selector(clickLeftButtonItem) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createVerifyTimer {
    _verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(runVerifyTimer) userInfo:nil repeats:YES];
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
        } else {
            [Util ShowTSMessageError:@"无法获取到验证码"];
        }
    }];
}

- (void)clickRightButtonItem{
    
    if ([_inputVerifyView.verifyCodeTextField.text isEqualToString:_verifyCode]) {
        NSMutableDictionary *param = [[DDUserManager currentUser] dictionaryFromModel];
        [DDUserManager DDRegister:[param copy] withBlock:^(BOOL success) {
            if (success) {
                [Util ShowTSMessageSuccess:@"👼求PS大神欢迎你的加入❗️"];
                [self.navigationController setViewControllers:nil];
                [AppDelegate APP].mainTabBarController = nil;
                [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTabBarController];
            }
        }];
    } else {
        [Util ShowTSMessageError:@"验证码错误哦"];
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
