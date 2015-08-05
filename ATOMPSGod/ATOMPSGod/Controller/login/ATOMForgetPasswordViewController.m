//
//  ATOMForgetPasswordViewController.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/5/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMForgetPasswordViewController.h"
#import "ATOMInputVerifyCodeAndPasswordViewController.h"
#import "ATOMInputMobileView.h"
#import "ATOMGetMoblieCode.h"
@interface ATOMForgetPasswordViewController () <UITextFieldDelegate>

@property (nonatomic, strong) ATOMInputMobileView *inputMobileView;

@end

@implementation ATOMForgetPasswordViewController
#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    _inputMobileView = [ATOMInputMobileView new];
    self.view = _inputMobileView;
    _inputMobileView.mobileTextField.delegate = self;
    [_inputMobileView.nextButton addTarget:self action:@selector(clickRightButtonItem) forControlEvents:UIControlEventTouchUpInside];
    [_inputMobileView.backButton addTarget:self action:@selector(clickLeftButtonItem) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}
#pragma mark - Click Event
- (void)clickLeftButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickRightButtonItem {
    if ([self checkInputMessageSuccess]) {
        ATOMGetMoblieCode *getMobileCode = [ATOMGetMoblieCode new];
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_inputMobileView.mobileTextField.text, @"phone", nil];
        [getMobileCode GetMobileCode:param withBlock:^(NSString *verifyCode, NSError *error) {
            if (verifyCode && !error) {
                [ATOMCurrentUser currentUser].mobile = _inputMobileView.mobileTextField.text;
                ATOMInputVerifyCodeAndPasswordViewController *ivcvc = [ATOMInputVerifyCodeAndPasswordViewController new];
                ivcvc.verifyCode = verifyCode;
                ivcvc.phoneNumber = _inputMobileView.mobileTextField.text;

                [self.navigationController pushViewController:ivcvc animated:YES];
            } else {
                
            }
        }];
    }
}

- (BOOL)checkInputMessageSuccess {
    BOOL flag = YES;
    NSString *mobileStr = _inputMobileView.mobileTextField.text;
    if (![mobileStr isMobileNumber]) {
        flag = NO;
        [Util ShowTSMessageWarn:@"请输入正确的手机号"];
    }
    return flag;
}

#pragma UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
