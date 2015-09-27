//
//  ATOMLoginView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMLoginView.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface ATOMLoginView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *tipLabel1;
@end
#define kTextColor [UIColor colorWithHex:0x637685];

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
    
    self.backgroundColor = [UIColor whiteColor];
    _backButton = [UIButton new];
    [_backButton setImage:[UIImage imageNamed:@"icon_back_login"] forState:UIControlStateNormal];
    [self addSubview:_backButton];
    
//    UILabel* backButtonLabel = [UILabel new];
//    backButtonLabel.text = @"登录";
//    backButtonLabel.textColor = kTextColor;
//    backButtonLabel.font = [UIFont systemFontOfSize:18.0];
//    [self addSubview:backButtonLabel];

    _mobileTextField = [UITextField new];
    _mobileTextField.placeholder = @"手机号";
    _mobileTextField.textColor = kTextColor;
    _mobileTextField.font = [UIFont systemFontOfSize:15];
    _mobileTextField.keyboardType = UIKeyboardTypePhonePad;
    _mobileTextField.delegate = self;
    [self addSubview:_mobileTextField];
    
    UIView * mobileBottomLine = [UIView new];
    mobileBottomLine.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.2];
    [self addSubview:mobileBottomLine];
    
    _passwordTextField = [UITextField new];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.placeholder = @"密码";
    _passwordTextField.textColor = kTextColor;
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    _passwordTextField.delegate = self;

    [self addSubview:_passwordTextField];
    
    UIView * passwordBottomLine = [UIView new];
    passwordBottomLine.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.2];
    [self addSubview:passwordBottomLine];
    
    _loginButton = [UIButton new];
    _loginButton.backgroundColor = [UIColor colorWithHex:PIEColorHex];
    _loginButton.layer.cornerRadius = 15;
    _loginButton.layer.masksToBounds = YES;
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self addSubview:_loginButton];
    
    _forgetPasswordButton = [UIButton new];
    _forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [_forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetPasswordButton setTitleColor:[UIColor colorWithHex:0x838383] forState:UIControlStateNormal];
    [_forgetPasswordButton setTitleColor:[UIColor colorWithHex:0x838383 andAlpha:0.2] forState:UIControlStateHighlighted];

    [self addSubview:_forgetPasswordButton];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.2];
    [self addSubview:_lineView];
    
    _tipLabel1 = [UILabel new];
    _tipLabel1.text = @"第三方登录";
    _tipLabel1.backgroundColor = self.backgroundColor;
    _tipLabel1.textColor = [UIColor colorWithHex:0xB5C0C8];
    _tipLabel1.font = [UIFont systemFontOfSize:14];
    _tipLabel1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_tipLabel1];
    
    _wechatLoginButton = [UIButton new];
    _wechatLoginButton.backgroundColor = [UIColor colorWithHex:0xB5C0C8 andAlpha:0.7];
    [_wechatLoginButton setTitle:@"微信登录" forState:UIControlStateNormal];
    [_wechatLoginButton setImage:[UIImage imageNamed:@"wechat_login"] forState:UIControlStateNormal];
    _wechatLoginButton.titleLabel.font = [UIFont systemFontOfSize:kFont15];
    _wechatLoginButton.layer.cornerRadius =  5;
    _wechatLoginButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    _weiboLoginButton = [UIButton new];
    _weiboLoginButton.backgroundColor = [UIColor colorWithHex:0xB5C0C8 andAlpha:0.7];
    [_weiboLoginButton setTitle:@"微博登录" forState:UIControlStateNormal];
    [_weiboLoginButton setImage:[UIImage imageNamed:@"weibo_login"] forState:UIControlStateNormal];
    _weiboLoginButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    _weiboLoginButton.titleLabel.font = [UIFont systemFontOfSize:kFont15];
    _weiboLoginButton.layer.cornerRadius =  5;

    [self addSubview:_wechatLoginButton];
    [self addSubview:_weiboLoginButton];
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left).with.offset(kPadding15);
        make.top.equalTo(ws.mas_top).with.offset(kPadding30);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
//    [backButtonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(ws.mas_centerX);
//        make.centerY.equalTo(_backButton.mas_centerY);
//        make.height.equalTo(@40);
//        make.width.equalTo(@40);
//    }];
    [_mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(_backButton.mas_top).with.offset(80);
        make.width.equalTo(@(kLineWidth));
        make.height.equalTo(@40);
    }];
    
    [mobileBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(_mobileTextField.mas_bottom).with.offset(0);
        make.width.equalTo(@(kLineWidth));
        make.height.equalTo(@0.5);
    }];
    
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.mobileTextField.mas_bottom).with.offset(30);
        make.width.equalTo(ws.mobileTextField);
        make.height.equalTo(ws.mobileTextField);
    }];
    
    [passwordBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(_passwordTextField.mas_bottom).with.offset(0);
        make.width.equalTo(@(kLineWidth));
        make.height.equalTo(@0.5);
    }];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.passwordTextField.mas_bottom).with.offset(50);
        make.width.equalTo(passwordBottomLine);
        make.height.equalTo(@35);
    }];
    
    [_forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.passwordTextField);
        make.top.equalTo(ws.passwordTextField.mas_bottom).with.offset(10);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.loginButton.mas_bottom).with.offset(40);
        make.width.equalTo(@240);
        make.height.equalTo(@1);
    }];
    
    [_tipLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.centerY.equalTo(ws.lineView.mas_centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    
    [_wechatLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.lineView.mas_left);
        make.top.equalTo(ws.tipLabel1.mas_bottom).with.offset(20);
        make.width.equalTo(@116);
        make.height.equalTo(@44);
    }];
    
    [_weiboLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.lineView.mas_right);
        make.top.equalTo(_wechatLoginButton.mas_top);
        make.width.equalTo(_wechatLoginButton.mas_width);
        make.height.equalTo(_wechatLoginButton.mas_height);
    }];

}


- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    if (textField == _mobileTextField) {
        return ((newLength <= 11) || returnKey);

    } else if (textField == _passwordTextField) {
        return ((newLength <= 16) || returnKey);
    }
    
    return YES;
}





@end
