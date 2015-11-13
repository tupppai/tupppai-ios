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
@property (nonatomic, assign) BOOL flag;
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
    _flag = YES;
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
   [self checkInputMessageSuccess:^(BOOL canNext) {
       if (canNext) {
           NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_mobileRegisterView.mobileTextField.text, @"phone", nil];
           [DDService getAuthCode:param withBlock:^(NSString* authcode) {
               if (authcode) {
                   [DDUserManager currentUser].mobile = _mobileRegisterView.mobileTextField.text;
                   [DDUserManager currentUser].password = [_mobileRegisterView.passwordTextField.text sha1];
                   DDAuthcodeVC *ivcvc = [DDAuthcodeVC new];
                   ivcvc.verifyCode = authcode;
                   [self.navigationController pushViewController:ivcvc animated:YES];
               }
               else {
                   [Util ShowTSMessageError:@"无法获取到验证码"];
               }
           }];
       }
   }];
}

- (BOOL)checkInputMessageSuccess:(void (^)(BOOL canNext))block {
    NSString *mobileStr = _mobileRegisterView.mobileTextField.text;
    NSString *passwordStr = _mobileRegisterView.passwordTextField.text;
    if (![mobileStr isMobileNumber]) {
        if (block) { block(NO);}
        [Util ShowTSMessageWarn:@"请输入正确的手机号"];
    }
    else if ([DDUserManager currentUser].signUpType == ATOMSignUpMobile ) {
                NSDictionary* param = [[NSDictionary alloc]initWithObjectsAndKeys:_mobileRegisterView.mobileTextField.text,@"phone", nil];
                [DDService checkPhoneRegistration:param withBlock:^(BOOL isRegistered) {
                    if (isRegistered) {
                        [Util ShowTSMessageWarn:@"此手机号已注册"];
                        if (block) { block(NO);}
                    } else if (![passwordStr isPassword]) {
                        [Util ShowTSMessageWarn:@"密码必须由6~16的位的数字和字母组成"];
                        if (block) { block(NO);}
                    }
                    else {
                        if (block) { block(YES);}
                    }
                }];
    }else {
        if (block) { block(YES);}
    }
    
    
    return _flag;
}

#pragma UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _mobileRegisterView.mobileTextField && ![_mobileRegisterView.mobileTextField.text  isEqualToString: @""]) {
        NSDictionary* param = [[NSDictionary alloc]initWithObjectsAndKeys:_mobileRegisterView.mobileTextField.text,@"phone", nil];
        if (![_mobileRegisterView.mobileTextField.text isMobileNumber]) {
            [Util ShowTSMessageWarn:@"请输入正确的手机号"];
        }
        else if ([DDUserManager currentUser].signUpType == ATOMSignUpMobile )

        {
            [DDService checkPhoneRegistration:param withBlock:^(BOOL isRegistered) {
                if (isRegistered) {
                    [Util ShowTSMessageWarn:@"此手机号已注册"];
                }
            }];
        }
    }
    else if (textField == _mobileRegisterView.passwordTextField && ![_mobileRegisterView.passwordTextField.text  isEqualToString: @""]) {
        if (![_mobileRegisterView.passwordTextField.text isPassword]) {
            [Util ShowTSMessageWarn:@"密码必须由6~16的位的数字和字母组成"];
        }
    }
}



@end
