//
//  ATOMModifyPasswordView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMModifyPasswordView.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface ATOMModifyPasswordView ()



@end

@implementation ATOMModifyPasswordView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    WS(ws);

    _oldPasswordTextField = [UITextField new];
    _oldPasswordTextField.secureTextEntry = YES;
    _oldPasswordTextField.placeholder = @"输入旧密码";
    _oldPasswordTextField.font = [UIFont systemFontOfSize:19];
    [self addSubview:_oldPasswordTextField];

    
    _modifyPasswordTextField = [UITextField new];
    _modifyPasswordTextField.secureTextEntry = YES;
    _modifyPasswordTextField.placeholder = @"输入新密码";
    _modifyPasswordTextField.font = [UIFont systemFontOfSize:19];
    [self addSubview:_modifyPasswordTextField];

    _confirmPasswordTextField = [UITextField new];
    _confirmPasswordTextField.secureTextEntry = YES;
    _confirmPasswordTextField.placeholder = @"再次输入新密码";
    _confirmPasswordTextField.font = [UIFont systemFontOfSize:19];
    [self addSubview:_confirmPasswordTextField];

    _forgetPasswordButton = [UIButton new];
    [_forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetPasswordButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize: 14];
    [self addSubview:_forgetPasswordButton];

    [_oldPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws).with.offset(40);
        make.width.equalTo(@250);
        make.height.equalTo(@50);
    }];
    
    [_modifyPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.oldPasswordTextField.mas_bottom).with.offset(20);
        make.width.equalTo(ws.oldPasswordTextField);
        make.height.equalTo(ws.oldPasswordTextField);
    }];
    
    [_confirmPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.modifyPasswordTextField.mas_bottom).with.offset(20);
        make.width.equalTo(ws.oldPasswordTextField);
        make.height.equalTo(ws.oldPasswordTextField);
    }];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, 40, kLineWidth, 0.5);
    bottomBorder.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.2].CGColor;
    
    CALayer *bottomBorder2 = [CALayer layer];
    bottomBorder2.frame = CGRectMake(0, 40, kLineWidth, 0.5);
    bottomBorder2.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.2].CGColor;
    CALayer *bottomBorder3 = [CALayer layer];
    bottomBorder3.frame = CGRectMake(0, 40, kLineWidth, 0.5);
    bottomBorder3.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.2].CGColor;
    
    [_oldPasswordTextField.layer addSublayer:bottomBorder];
    [_modifyPasswordTextField.layer addSublayer:bottomBorder2];
    [_confirmPasswordTextField.layer addSublayer:bottomBorder3];

    [_forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.confirmPasswordTextField.mas_bottom).with.offset(5);
        make.right.equalTo(ws.confirmPasswordTextField.mas_right);
        make.width.equalTo(@100);
        make.height.equalTo(@5);
    }];

}



@end
