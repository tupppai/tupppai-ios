//
//  ATOMInputMobileView.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/5/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMInputMobileView.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;
@implementation ATOMInputMobileView

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
    
    [_mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(self).with.offset(90);
        make.left.equalTo(ws.mas_left).with.offset(20);
        make.right.equalTo(ws.mas_right).with.offset(-20);
        make.height.equalTo(@50);
    }];

    
    UIView * mobileBottomLine = [UIView new];
    mobileBottomLine.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.2];
    [self addSubview:mobileBottomLine];

    
    [mobileBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(_mobileTextField.mas_bottom).with.offset(2);
        make.width.equalTo(@(kLineWidth));
        make.height.equalTo(@0.5);
    }];
}

@end
