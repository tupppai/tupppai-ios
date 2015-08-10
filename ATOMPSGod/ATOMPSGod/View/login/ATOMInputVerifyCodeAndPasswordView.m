//
//  ATOMInputVerifyCodeAndPasswordView.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/5/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMInputVerifyCodeAndPasswordView.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;
@interface ATOMInputVerifyCodeAndPasswordView ()

//@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, copy) NSString *buttonTitleStr;

@end
@implementation ATOMInputVerifyCodeAndPasswordView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    WS(ws);
    _lastSecond = 30;
    _backButton = [UIButton new];
    [_backButton setImage:[UIImage imageNamed:@"icon_back_login"] forState:UIControlStateNormal];
    [self addSubview:_backButton];
    
    UILabel *backButtonLabel = [UILabel new];
    backButtonLabel.text = @"输入验证码";
    backButtonLabel.textColor = [UIColor colorWithHex:0x637685];
    backButtonLabel.font = [UIFont systemFontOfSize:18.0];
    [self addSubview:backButtonLabel];
    
    _nextButton = [UIButton new];
    [_nextButton setTitle:@"完成" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor colorWithHex:0x637685] forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor colorWithHex:0x637685 andAlpha:0.2] forState:UIControlStateHighlighted];
    [self addSubview:_nextButton];
    
    _verifyCodeTextField = [UITextField new];
    _verifyCodeTextField.placeholder = @"输入验证码";
    _verifyCodeTextField.textAlignment = NSTextAlignmentCenter;
    _verifyCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _verifyCodeTextField.font = [UIFont systemFontOfSize:19];
    [self addSubview:_verifyCodeTextField];
    
    _passwordTextField = [UITextField new];
    _passwordTextField.placeholder = @"设置新密码";
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.textAlignment = NSTextAlignmentCenter;
    _passwordTextField.font = [UIFont systemFontOfSize:19];
    [self addSubview:_passwordTextField];
    
    
    _sendVerifyCodeButton = [UIButton new];
    _buttonTitleStr = [NSString stringWithFormat:@"%d秒后点此可重发验证码",(int)self.lastSecond];
    [_sendVerifyCodeButton setTitle:_buttonTitleStr forState:UIControlStateNormal];
    [_sendVerifyCodeButton setTitleColor:[UIColor colorWithHex:0xBDC7CE] forState:UIControlStateNormal];
    [self addSubview:_sendVerifyCodeButton];
    
//    UIView * BottomLine = [UIView new];
//    BottomLine.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.2];
//    [self addSubview:BottomLine];
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left).with.offset(kPadding15);
        make.top.equalTo(ws.mas_top).with.offset(kPadding30);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    [backButtonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.centerY.equalTo(_backButton.mas_centerY);
        make.height.equalTo(@40);
    }];
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.mas_right).with.offset(-kPadding15);
        make.centerY.equalTo(_backButton.mas_centerY);
        make.height.equalTo(@40);
    }];
    
    [_verifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws);
        make.width.equalTo(@(kLineWidth));
        make.top.equalTo(_backButton.mas_top).with.offset(90);
        make.height.equalTo(@40);
    }];
    
//    [BottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(ws.mas_centerX);
//        make.top.equalTo(_verifyCodeTextField.mas_bottom);
//        make.width.equalTo(@(kLineWidth));
//        make.height.equalTo(@0.5);
//    }];
    
    [_sendVerifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.verifyCodeTextField.mas_bottom).with.offset(10);
        make.left.equalTo(ws.verifyCodeTextField.mas_left);
        make.right.equalTo(ws.verifyCodeTextField.mas_right);
        make.height.equalTo(ws.verifyCodeTextField);
    }];
    
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.verifyCodeTextField);
        make.top.equalTo(ws.sendVerifyCodeButton.mas_bottom).with.offset(30);
        make.width.equalTo(ws.verifyCodeTextField);
        make.height.equalTo(ws.verifyCodeTextField);
    }];
    CALayer* BottomLine = [CALayer new];
    BottomLine.frame = CGRectMake(0,39,kLineWidth,0.5);
    BottomLine.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.2].CGColor;
    [_verifyCodeTextField.layer addSublayer:BottomLine];

    CALayer* pwdBottomLine = [CALayer new];
    pwdBottomLine.frame = CGRectMake(0,39,kLineWidth,0.5);
    pwdBottomLine.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.2].CGColor;
    [_passwordTextField.layer addSublayer:pwdBottomLine];
}

- (void)setLastSecond:(NSInteger)lastSecond {
    _lastSecond = lastSecond;
    if (_lastSecond <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _buttonTitleStr = @"重发验证码";
            [_sendVerifyCodeButton setTitle:_buttonTitleStr forState:UIControlStateNormal];
            [_sendVerifyCodeButton setTitleColor:[UIColor colorWithHex:0x74c3ff] forState:UIControlStateNormal];
            [_sendVerifyCodeButton setTitleColor:[UIColor colorWithHex:0x74c3ff andAlpha:0.2] forState:UIControlStateHighlighted];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            _buttonTitleStr = [NSString stringWithFormat:@"%d秒后点此可重发验证码",(int)_lastSecond];
            [_sendVerifyCodeButton setTitle:_buttonTitleStr forState:UIControlStateNormal];
            [_sendVerifyCodeButton setTitleColor:[UIColor colorWithHex:0xBDC7CE] forState:UIControlStateNormal];
        });
    }
    
}
@end
