//
//  ATOMMobileRegisterView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMobileRegisterView.h"

;

@interface ATOMMobileRegisterView ()
//
//@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation ATOMMobileRegisterView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    WS(ws);
    

    _mobileTextField = [UITextField new];
    _mobileTextField.placeholder = @"输入手机号";
    _mobileTextField.textAlignment = NSTextAlignmentCenter;
    _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    _mobileTextField.returnKeyType = UIReturnKeyDone;
    _mobileTextField.font = [UIFont systemFontOfSize:19];
    [_mobileTextField becomeFirstResponder];
    [self addSubview:_mobileTextField];

    _passwordTextField = [UITextField new];
    _passwordTextField.textAlignment = NSTextAlignmentCenter;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.placeholder = @"设置密码";
    _passwordTextField.font = [UIFont systemFontOfSize:19];
    [self addSubview:_passwordTextField];
    
    [_mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws).with.offset(90);
        make.left.equalTo(ws.mas_left).with.offset(20);
        make.right.equalTo(ws.mas_right).with.offset(-20);
        make.height.equalTo(@50);
    }];
    
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.mobileTextField.mas_bottom).with.offset(20);
        make.width.equalTo(ws.mobileTextField);
        make.height.equalTo(ws.mobileTextField);
    }];
    
    
    UIView * mobileBottomLine = [UIView new];
    mobileBottomLine.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.2];
    [self addSubview:mobileBottomLine];
    
    UIView * passwordBottomLine = [UIView new];
    passwordBottomLine.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.2];
    [self addSubview:passwordBottomLine];
    
    [mobileBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(_mobileTextField.mas_bottom).with.offset(2);
        make.width.equalTo(@(kLineWidth));
        make.height.equalTo(@0.5);
    }];
    [passwordBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(_passwordTextField.mas_bottom).with.offset(2);
        make.width.equalTo(@(kLineWidth));
        make.height.equalTo(@0.5);
    }];
}










@end
