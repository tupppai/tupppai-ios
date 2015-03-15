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
        self.backgroundColor = [UIColor colorWithHex:0xededed];
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    WS(ws);
    
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13.f], NSFontAttributeName, nil];
    
    UILabel *oldPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 81.5, 40)];
    oldPasswordLabel.text = @"旧密码";
    _oldPasswordTextField = [UITextField new];
    _oldPasswordTextField.secureTextEntry = YES;
    _oldPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入你的旧密码" attributes:attributeDict];
    [self setCommonTextField:_oldPasswordTextField AndLabel:oldPasswordLabel];
    
    UILabel *modifyPasswordLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 81.5, 40)];
    modifyPasswordLabel.text = @"新密码";
    _modifyPasswordTextField = [UITextField new];
    _modifyPasswordTextField.secureTextEntry = YES;
    _modifyPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"6-16位字符，区分大小写" attributes:attributeDict];
    [self setCommonTextField:_modifyPasswordTextField AndLabel:modifyPasswordLabel];
    
    UILabel *confirmPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 81.5, 40)];
    confirmPasswordLabel.text = @"确认密码";
    _confirmPasswordTextField = [UITextField new];
    _confirmPasswordTextField.secureTextEntry = YES;
    _confirmPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"重复新密码" attributes:attributeDict];
    [self setCommonTextField:_confirmPasswordTextField AndLabel:confirmPasswordLabel];
    
    _forgetPasswordButton = [UIButton new];
    _forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [_forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetPasswordButton setTitleColor:[UIColor colorWithHex:0x838383] forState:UIControlStateNormal];
    [self addSubview:_forgetPasswordButton];
    
    [_oldPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.mas_top).with.offset(15);
        make.left.equalTo(ws.mas_left).with.offset(20);
        make.right.equalTo(ws.mas_right).with.offset(-20);
        make.height.equalTo(@40);
    }];
    
    [_modifyPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.oldPasswordTextField.mas_bottom).with.offset(10);
        make.width.equalTo(ws.oldPasswordTextField);
        make.height.equalTo(ws.oldPasswordTextField);
    }];
    
    [_confirmPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.modifyPasswordTextField.mas_bottom).with.offset(10);
        make.width.equalTo(ws.modifyPasswordTextField);
        make.height.equalTo(ws.modifyPasswordTextField);
    }];
    
    [_forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.confirmPasswordTextField);
        make.top.equalTo(ws.confirmPasswordTextField.mas_bottom).with.offset(10);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    
}

- (void)setCommonTextField:(UITextField *)textField AndLabel:(UILabel *)label {
    [self addSubview:_oldPasswordTextField];
    label.backgroundColor = [UIColor colorWithHex:0x9c9c9c];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = label;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self addSubview:textField];
}

@end
