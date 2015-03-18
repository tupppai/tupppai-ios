//
//  ATOMMobileRegisterView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMobileRegisterView.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface ATOMMobileRegisterView ()

@property (nonatomic, strong) UILabel *tipLabel;

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
    UILabel *mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 81.5, 40)];
    mobileLabel.backgroundColor = [UIColor colorWithHex:0x32bef3];
    mobileLabel.text = @"+86";
    mobileLabel.textAlignment = NSTextAlignmentCenter;
    mobileLabel.textColor = [UIColor whiteColor];
    mobileLabel.layer.cornerRadius = 5;
    mobileLabel.layer.masksToBounds = YES;
    _mobileTextField = [UITextField new];
    _mobileTextField.borderStyle = UITextBorderStyleRoundedRect;
    _mobileTextField.leftViewMode = UITextFieldViewModeAlways;
    _mobileTextField.placeholder = @"输入你的手机号";
    _mobileTextField.leftView = mobileLabel;
    _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    _mobileTextField.returnKeyType = UIReturnKeyDone;
    [self addSubview:_mobileTextField];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 81.5, 40)];
    passwordLabel.backgroundColor = [UIColor colorWithHex:0x9c9c9c];
    passwordLabel.text = @"密码";
    passwordLabel.textAlignment = NSTextAlignmentCenter;
    passwordLabel.textColor = [UIColor whiteColor];
    passwordLabel.layer.cornerRadius = 5;
    passwordLabel.layer.masksToBounds = YES;
    _passwordTextField = [UITextField new];
    _passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.placeholder = @"设置你的密码";
    _passwordTextField.leftView = passwordLabel;
    [self addSubview:_passwordTextField];
    
    _tipLabel = [UILabel new];
    _tipLabel.text=@"请设置登陆求PS大神的手机号码和密码";
    _tipLabel.font = [UIFont systemFontOfSize:14.f];
    _tipLabel.textColor = [UIColor colorWithHex:0x9c9c9c];
    [self addSubview:_tipLabel];
    
    [_mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.mas_top).with.offset(15);
        make.left.equalTo(ws.mas_left).with.offset(20);
        make.right.equalTo(ws.mas_right).with.offset(-20);
        make.height.equalTo(@40);
    }];
    
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.mobileTextField.mas_bottom).with.offset(10);
        make.width.equalTo(ws.mobileTextField);
        make.height.equalTo(ws.mobileTextField);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.passwordTextField.mas_bottom);
        make.width.equalTo(ws.passwordTextField);
        make.height.equalTo(@48);
    }];
    
}










@end
