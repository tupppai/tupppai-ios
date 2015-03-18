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
    self.title = @"手机注册";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    _mobileRegisterView = [ATOMMobileRegisterView new];
    self.view = _mobileRegisterView;
    _mobileRegisterView.mobileTextField.delegate = self;
    _mobileRegisterView.passwordTextField.delegate = self;
}

#pragma mark - Click Event

- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
    if (![self checkInputMessageSuccess]) {
        return ;
    }
    [UIAlertView showWithTitle:nil message:@"确认手机号码\n我们将发验证码到此号码" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == [alertView cancelButtonIndex]) {
            NSLog(@"Cancelled");
        } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"]) {
            NSLog(@"confirmed");
            ATOMGetMoblieCode *getMobileCode = [ATOMGetMoblieCode new];
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_mobileRegisterView.mobileTextField.text, @"phone", nil];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
            [getMobileCode GetMobileCode:param withBlock:^(NSString *verifyCode, NSError *error) {
                [SVProgressHUD dismiss];
                if (verifyCode) {
                    [ATOMCurrentUser currentUser].mobile = _mobileRegisterView.mobileTextField.text;
                    [ATOMCurrentUser currentUser].password = [_mobileRegisterView.passwordTextField.text sha1];
                    NSLog(@"%@",[ATOMCurrentUser currentUser].password);
                    ATOMInputVerifyCodeViewController *ivcvc = [ATOMInputVerifyCodeViewController new];
                    ivcvc.verifyCode = verifyCode;
                    [self.navigationController pushViewController:ivcvc animated:YES];
                }
            }];

        }
    }];
}

- (BOOL)checkInputMessageSuccess {
    BOOL flag = YES;
    NSString *mobileStr = _mobileRegisterView.mobileTextField.text;
    NSString *passwordStr = _mobileRegisterView.passwordTextField.text;
    if (![mobileStr isMobileNumber]) {
        flag = NO;
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号..."];
    } else if (![passwordStr isPassword]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的密码..."];
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
