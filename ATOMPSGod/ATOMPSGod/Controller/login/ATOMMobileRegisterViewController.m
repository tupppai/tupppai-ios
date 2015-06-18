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
    rightButtonItem.tintColor = [UIColor whiteColor];
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
            ATOMGetMoblieCode *getMobileCode = [ATOMGetMoblieCode new];
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_mobileRegisterView.mobileTextField.text, @"phone", nil];
            [getMobileCode GetMobileCode:param withBlock:^(NSString *verifyCode, NSError *error) {
                if (verifyCode) {
                    [ATOMCurrentUser currentUser].mobile = _mobileRegisterView.mobileTextField.text;
                    [ATOMCurrentUser currentUser].password = [_mobileRegisterView.passwordTextField.text sha1];
                    NSLog(@"sha1 password%@",[ATOMCurrentUser currentUser].password);
                    ATOMInputVerifyCodeViewController *ivcvc = [ATOMInputVerifyCodeViewController new];
                    ivcvc.verifyCode = verifyCode;
                    [self.navigationController pushViewController:ivcvc animated:YES];
                } else {
                    [Util TextHud:@"出现未知错误"];
                }
            }];
}

- (BOOL)checkInputMessageSuccess {
    BOOL flag = YES;
    NSString *mobileStr = _mobileRegisterView.mobileTextField.text;
    NSString *passwordStr = _mobileRegisterView.passwordTextField.text;
    if (![mobileStr isMobileNumber]) {
        flag = NO;
        [Util TextHud:@"请输入正确的手机号"];
    } else if (![passwordStr isPassword]) {
        [Util TextHud:@"请输入正确的密码"];
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
