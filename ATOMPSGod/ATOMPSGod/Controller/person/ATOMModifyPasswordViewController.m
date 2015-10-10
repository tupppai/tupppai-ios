//
//  ATOMModifyPasswordViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMModifyPasswordViewController.h"
#import "ATOMModifyPasswordView.h"
#import "DDService.h"
#import "DDInputPhoneFPVC.h"

@interface ATOMModifyPasswordViewController ()

@property (nonatomic, strong) ATOMModifyPasswordView *modifyPasswordView;

@end

@implementation ATOMModifyPasswordViewController

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"完成修改" style:UIBarButtonItemStyleDone target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = btnDone;
}
- (void)createUI {
    self.title = @"修改密码";
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
        [DDService updatePassword:param withBlock:^(BOOL success, NSInteger ret) {
            if (success) {
                if (ret == 1) {
                    [Util ShowTSMessageSuccess:@"修改密码成功"];
                } else if (ret == 2) {
                    [Util ShowTSMessageError:@"原密码错误"];
                    
                } else if (ret == 3) {
                    [Util ShowTSMessageError:@"原密码与新密码相同"];
                } else {
                    [Util ShowTSMessageError:@"修改密码失败"];
                }
            }
        }];

    }
}


- (void)clickForgetPasswordButton:(UIButton *)sender {
    DDInputPhoneFPVC* fpvc = [DDInputPhoneFPVC new];
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
