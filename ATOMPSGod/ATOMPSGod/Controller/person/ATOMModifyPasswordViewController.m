//
//  ATOMModifyPasswordViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMModifyPasswordViewController.h"
#import "ATOMModifyPasswordView.h"
#import "ATOMBaseRequest.h"
#import "ATOMForgetPasswordViewController.h"

@interface ATOMModifyPasswordViewController ()

@property (nonatomic, strong) ATOMModifyPasswordView *modifyPasswordView;

@end

@implementation ATOMModifyPasswordViewController

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)createUI {
    self.title = @"修改密码";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _modifyPasswordView = [ATOMModifyPasswordView new];
    self.view = _modifyPasswordView;
    [_modifyPasswordView.forgetPasswordButton addTarget:self action:@selector(clickForgetPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Click Event

- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
    if ([self isNewPasswordAccepted]) {
        NSMutableDictionary* param = [NSMutableDictionary new];
        [param setObject:_modifyPasswordView.oldPasswordTextField.text forKey:@"old_pwd"];
        [param setObject:_modifyPasswordView.modifyPasswordTextField.text forKey:@"new_pwd"];

        [ATOMBaseRequest post:param withUrl:@"profile/updatePassword" withBlock:^(NSError *error, int ret) {
            if (error == nil) {
                if (ret == 1) {
                    [Util ShowTSMessageSuccess:@"修改密码成功"];
                } else if (ret == 2) {
                    [Util ShowTSMessageError:@"原密码错误"];

                } else if (ret == 3) {
                    [Util ShowTSMessageError:@"原密码与新密码相同"];
                } else {
                    [Util ShowTSMessageError:@"修改密码失败"];
                }
            } else {
                [Util ShowTSMessageError:@"修改密码失败"];
            }
        }];
    }
}


- (void)clickForgetPasswordButton:(UIButton *)sender {
    ATOMForgetPasswordViewController* fpvc = [ATOMForgetPasswordViewController new];
    [self.navigationController pushViewController:fpvc animated:YES];
}
- (BOOL)isNewPasswordAccepted {
    if (![_modifyPasswordView.oldPasswordTextField.text isPassword]){
        [Util ShowTSMessageWarn:@"旧密码还没正确输入"];
        return NO;
    } else if (![_modifyPasswordView.modifyPasswordTextField.text isEqualToString:_modifyPasswordView.confirmPasswordTextField.text]) {
        [Util ShowTSMessageWarn:@"两次输入的新密码不一致"];
        return NO;
    } else if (![_modifyPasswordView.modifyPasswordTextField.text isPassword] || ![_modifyPasswordView.confirmPasswordTextField.text isPassword]) {
        [Util ShowTSMessageWarn:@"新密码必须由6~16位的数字和字母组成"];
        return NO;
    } else  {
        return YES;
    }
}

@end
