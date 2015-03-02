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

@property (nonatomic, strong) UILabel *tipLabel;
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
    UILabel *verifyCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 81.5, 40)];
    verifyCodeLabel.backgroundColor = [UIColor colorWithHex:0xb0b0b0];
    verifyCodeLabel.text = @"验证码";
    verifyCodeLabel.textAlignment = NSTextAlignmentCenter;
    verifyCodeLabel.textColor = [UIColor whiteColor];
    verifyCodeLabel.layer.cornerRadius = 5;
    verifyCodeLabel.layer.masksToBounds = YES;
    _verifyCodeTextField = [UITextField new];
    _verifyCodeTextField.borderStyle = UITextBorderStyleRoundedRect;
    _verifyCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    _verifyCodeTextField.placeholder = @"输入你的验证码";
    _verifyCodeTextField.leftView = verifyCodeLabel;
    [self addSubview:_verifyCodeTextField];
    
    _tipLabel = [UILabel new];
    _tipLabel.text = @"未收到请点击重新发送验证码";
    _tipLabel.font = [UIFont systemFontOfSize:14.f];
    _tipLabel.textColor = [UIColor colorWithHex:0x838383];
    [self addSubview:_tipLabel];
    
    _sendVerifyCodeButton = [UIButton new];
    _sendVerifyCodeButton.backgroundColor = [UIColor colorWithHex:0xb0b0b0];

    _buttonTitleStr = [NSString stringWithFormat:@"点击重新发送( %d )",(int)self.lastSecond];
    [_sendVerifyCodeButton setTitle:_buttonTitleStr forState:UIControlStateNormal];
    [_sendVerifyCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sendVerifyCodeButton.layer.cornerRadius = 5;
    _sendVerifyCodeButton.layer.masksToBounds = YES;
    [self addSubview:_sendVerifyCodeButton];
    
    [_verifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left).with.offset(10);
        make.right.equalTo(ws.mas_right).with.offset(-10);
        make.top.equalTo(ws.mas_top).with.offset(15);
        make.height.equalTo(@40);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.verifyCodeTextField.mas_left);
        make.right.equalTo(ws.verifyCodeTextField.mas_right);
        make.top.equalTo(ws.verifyCodeTextField.mas_bottom);
        make.height.equalTo(ws.verifyCodeTextField);
    }];
    
    [_sendVerifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.verifyCodeTextField.mas_left);
        make.right.equalTo(ws.verifyCodeTextField.mas_right);
        make.top.equalTo(ws.tipLabel.mas_bottom);
        make.height.equalTo(ws.verifyCodeTextField);
    }];
    
    
}

- (void)setLastSecond:(NSInteger)lastSecond {
    _lastSecond = lastSecond;
    dispatch_async(dispatch_get_main_queue(), ^{
        _buttonTitleStr = [NSString stringWithFormat:@"点击重新发送( %d )",(int)_lastSecond];
        [_sendVerifyCodeButton setTitle:_buttonTitleStr forState:UIControlStateNormal];
    });
}   












@end
