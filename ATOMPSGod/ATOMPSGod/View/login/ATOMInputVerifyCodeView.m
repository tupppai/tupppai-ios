//
//  ATOMInputVerifyCodeView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMInputVerifyCodeView.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface ATOMInputVerifyCodeView ()

//@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, copy) NSString *buttonTitleStr;

@end

@implementation ATOMInputVerifyCodeView

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

    
    _verifyCodeTextField = [UITextField new];
    _verifyCodeTextField.placeholder = @"输入验证码";
    _verifyCodeTextField.textAlignment = NSTextAlignmentCenter;
    _verifyCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _verifyCodeTextField.font = [UIFont systemFontOfSize:19];
    [self addSubview:_verifyCodeTextField];
    
    _sendVerifyCodeButton = [UIButton new];
    _buttonTitleStr = [NSString stringWithFormat:@"%d秒后点此可重发验证码",(int)self.lastSecond];
    [_sendVerifyCodeButton setTitle:_buttonTitleStr forState:UIControlStateNormal];
    [_sendVerifyCodeButton setTitleColor:[UIColor colorWithHex:0xBDC7CE] forState:UIControlStateNormal];
    _sendVerifyCodeButton.userInteractionEnabled = NO;
    [self addSubview:_sendVerifyCodeButton];
    
    UIView * BottomLine = [UIView new];
    BottomLine.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.2];
    [self addSubview:BottomLine];
    
    [_verifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left).with.offset(10);
        make.right.equalTo(ws.mas_right).with.offset(-10);
        make.top.equalTo(self).with.offset(90);
        make.height.equalTo(@40);
    }];
    
    [BottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(_verifyCodeTextField.mas_bottom).with.offset(10);
        make.width.equalTo(@(kLineWidth));
        make.height.equalTo(@0.5);
    }];
    
    [_sendVerifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.verifyCodeTextField.mas_bottom).with.offset(10);
        make.left.equalTo(ws.verifyCodeTextField.mas_left);
        make.right.equalTo(ws.verifyCodeTextField.mas_right);
        make.height.equalTo(ws.verifyCodeTextField);
    }];
    
    
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
