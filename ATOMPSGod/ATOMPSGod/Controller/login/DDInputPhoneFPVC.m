//
//  ATOMForgetPasswordViewController.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/5/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "DDInputPhoneFPVC.h"
#import "DDInputAuthcodePwdFPVC.h"
#import "ATOMInputMobileView.h"
@interface DDInputPhoneFPVC () <UITextFieldDelegate>

@property (nonatomic, strong) ATOMInputMobileView *inputMobileView;

@end

@implementation DDInputPhoneFPVC
#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    _inputMobileView = [ATOMInputMobileView new];
    self.view = _inputMobileView;
    _inputMobileView.mobileTextField.delegate = self;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(clickRightButtonItem)];
    self.navigationItem.rightBarButtonItem = btnDone;
}

#pragma mark - Click Event
- (void)clickLeftButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickRightButtonItem {
    if ([self checkInputMessageSuccess]) {
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_inputMobileView.mobileTextField.text, @"phone", nil];
        [DDService getAuthCode:param withBlock:^(BOOL success) {
            if (success) {
                [DDUserManager currentUser].mobile = _inputMobileView.mobileTextField.text;
                DDInputAuthcodePwdFPVC *ivcvc = [DDInputAuthcodePwdFPVC new];
//                ivcvc.verifyCode = authcode;
                ivcvc.phoneNumber = _inputMobileView.mobileTextField.text;
                [self.navigationController pushViewController:ivcvc animated:YES];            }
            else {
                [Util ShowTSMessageError:@"无法获取到验证码"];
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
