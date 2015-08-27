//
//  ATOMInputVerifyCode.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDAuthcodeVC.h"
#import "ATOMInputVerifyCodeView.h"
#import "ATOMSubmitUserInfomation.h"
#import "AppDelegate.h"
//#import "ATOMLoginViewController.h"
#import "DDTabBarController.h"
#import "ATOMGetMoblieCode.h"

@interface DDAuthcodeVC ()

@property (nonatomic, strong) ATOMInputVerifyCodeView *inputVerifyView;
@property (nonatomic, strong) NSTimer *verifyTimer;
//@property (nonatomic, strong) NSDateFormatter *df;
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
    ATOMGetMoblieCode *getMobileCode = [ATOMGetMoblieCode new];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[DDUserModel currentUser].mobile, @"phone", nil];
    [getMobileCode GetMobileCode:param withBlock:^(NSString *verifyCode, NSError *error) {
        if (verifyCode && !error) {
            self.verifyCode = verifyCode;
        } else {
            [Util ShowTSMessageError:@"无法获取到验证码"];
        }
    }];
}

- (void)clickRightButtonItem{
    
    if ([_inputVerifyView.verifyCodeTextField.text isEqualToString:_verifyCode]) {
        NSMutableDictionary *param = [[DDUserModel currentUser] dictionaryFromModel];
        ATOMSubmitUserInformation *submitUserInformation = [ATOMSubmitUserInformation new];
        
        [submitUserInformation SubmitUserInformation:[param copy] withBlock:^(NSError *error) {
            if (!error) {
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
