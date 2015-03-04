//
//  ATOMLoginView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMLoginView.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface ATOMLoginView ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *tipLabel1;
@property (nonatomic, strong) UILabel *tipLabel2;

@property (nonatomic, strong) UILabel *xlLabel;
@property (nonatomic, strong) UILabel *wxLabel;
@property (nonatomic, strong) UILabel *qqLabel;

@end

@implementation ATOMLoginView

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
    mobileLabel.text = @"手机";
    mobileLabel.textAlignment = NSTextAlignmentCenter;
    mobileLabel.textColor = [UIColor whiteColor];
    mobileLabel.layer.cornerRadius = 5;
    mobileLabel.layer.masksToBounds = YES;
    _mobileTextField = [UITextField new];
    _mobileTextField.borderStyle = UITextBorderStyleRoundedRect;
    _mobileTextField.leftViewMode = UITextFieldViewModeAlways;
    _mobileTextField.placeholder = @"输入你的手机号";
    _mobileTextField.leftView = mobileLabel;
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
    
    _loginButton = [UIButton new];
    _loginButton.backgroundColor = [UIColor colorWithHex:0x32bef3];
    _loginButton.layer.cornerRadius = 5;
    _loginButton.layer.masksToBounds = YES;
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_loginButton];
    
    _forgetPasswordButton = [UIButton new];
    _forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [_forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetPasswordButton setTitleColor:[UIColor colorWithHex:0x838383] forState:UIControlStateNormal];
    [self addSubview:_forgetPasswordButton];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor colorWithHex:0x9b9b9b];
    [self addSubview:_lineView];
    
    _tipLabel1 = [UILabel new];
    _tipLabel1.backgroundColor = [UIColor colorWithHex:0xededed];
    _tipLabel1.text = @"或者";
    _tipLabel1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_tipLabel1];
    
    _tipLabel2 = [UILabel new];
//    _tipLabel2.backgroundColor = [UIColor purpleColor];
    _tipLabel2.text = @"社交账号快速登录";
    _tipLabel2.textColor = [UIColor colorWithHex:0x9b9b9b];
    _tipLabel2.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_tipLabel2];
    
    _xlLoginButton = [UIButton new];
    _wxLoginButton = [UIButton new];
    _qqLoginButton = [UIButton new];
    
    [_xlLoginButton setBackgroundImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
    [_wxLoginButton setBackgroundImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
    [_qqLoginButton setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    
    [self addSubview:_xlLoginButton];
    [self addSubview:_wxLoginButton];
    [self addSubview:_qqLoginButton];
    
    _xlLabel = [UILabel new];
    _wxLabel = [UILabel new];
    _qqLabel = [UILabel new];
    
    _xlLabel.text = @"新浪微博";
    _wxLabel.text = @"微信";
    _qqLabel.text = @"QQ";
    
    _xlLabel.textColor = [UIColor colorWithHex:0x9c9c9c];
    _wxLabel.textColor = [UIColor colorWithHex:0x9c9c9c];
    _qqLabel.textColor = [UIColor colorWithHex:0x9c9c9c];
    
    _xlLabel.textAlignment = NSTextAlignmentCenter;
    _wxLabel.textAlignment = NSTextAlignmentCenter;
    _qqLabel.textAlignment = NSTextAlignmentCenter;
    
    _xlLabel.font = [UIFont systemFontOfSize:12.f];
    _wxLabel.font = [UIFont systemFontOfSize:12.f];
    _qqLabel.font = [UIFont systemFontOfSize:12.f];
    
    [self addSubview:_xlLabel];
    [self addSubview:_wxLabel];
    [self addSubview:_qqLabel];
    
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
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.passwordTextField.mas_bottom).with.offset(55.5);
        make.width.equalTo(ws.mobileTextField);
        make.height.equalTo(ws.mobileTextField);
    }];
    
    [_forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.passwordTextField);
        make.top.equalTo(ws.passwordTextField.mas_bottom).with.offset(10);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.loginButton.mas_bottom).with.offset(56.5);
        make.width.equalTo(ws);
        make.height.equalTo(@1);
    }];
    
    [_tipLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.centerY.equalTo(ws.lineView.mas_centerY);
        make.width.equalTo(@80);
        make.height.equalTo(@40);
    }];
    
    [_tipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.tipLabel1.mas_bottom);
        make.height.equalTo(@30);
        make.width.equalTo(@140);
    }];
    
    [_xlLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.wxLoginButton.mas_left).with.offset(-36);
        make.top.equalTo(ws.tipLabel2.mas_bottom).with.offset(10);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    [_wxLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.xlLoginButton.mas_right).with.offset(36);
        make.right.equalTo(ws.qqLoginButton.mas_left).with.offset(-36);
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.xlLoginButton);
        make.width.equalTo(ws.xlLoginButton);
        make.height.equalTo(ws.xlLoginButton);
    }];
    
    [_qqLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.wxLoginButton.mas_right).with.offset(36);
        make.top.equalTo(ws.xlLoginButton);
        make.width.equalTo(ws.xlLoginButton);
        make.height.equalTo(ws.xlLoginButton);
    }];
    
    [_xlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.xlLoginButton);
        make.top.equalTo(ws.xlLoginButton.mas_bottom).with.offset(5);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
    }];
    
    [_wxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.wxLoginButton);
        make.top.equalTo(ws.xlLabel);
        make.width.equalTo(ws.xlLabel);
        make.height.equalTo(ws.xlLabel);
    }];
    
    [_qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.qqLoginButton);
        make.top.equalTo(ws.xlLabel);
        make.width.equalTo(ws.xlLabel);
        make.height.equalTo(ws.xlLabel);
    }];
    
    
    
}









@end
