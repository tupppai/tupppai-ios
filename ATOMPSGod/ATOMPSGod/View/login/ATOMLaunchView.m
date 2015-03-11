//
//  ATOMLaunchView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMLaunchView.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@implementation ATOMLaunchView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self updateSubView];
    }
    return self;
}

- (void)updateSubView {
    WS(ws);
    _wxRegisterButton = [UIButton new];
    _otherRegisterButton = [UIButton new];
    _loginButton = [UIButton new];
    
//    [_wxRegisterButton showPlaceHolder];
//    [_otherRegisterButton showPlaceHolder];
//    [_loginButton showPlaceHolder];
    
    [_wxRegisterButton setTitle:@"微信注册" forState:UIControlStateNormal];
    [_otherRegisterButton setTitle:@"其他方式注册" forState:UIControlStateNormal];
    [_loginButton setTitle:@"已有账号登陆" forState:UIControlStateNormal];
    
    _wxRegisterButton.backgroundColor = [UIColor colorWithHex:0x0881b9 andAlpha:0.7];
    _otherRegisterButton.backgroundColor = [UIColor colorWithHex:0x585858 andAlpha:0.7];
    
    [self addSubview:_wxRegisterButton];
    [self addSubview:_otherRegisterButton];
    [self addSubview:_loginButton];
    
    [_wxRegisterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.bottom.equalTo(ws.mas_bottom).with.offset(-117);
        make.width.equalTo(@199);
        make.height.equalTo(@32.5);
    }];
    
    [_otherRegisterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.bottom.equalTo(ws.mas_bottom).with.offset(-70.5);
        make.width.equalTo(ws.wxRegisterButton);
        make.height.equalTo(ws.wxRegisterButton);
    }];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.bottom.equalTo(ws.mas_bottom).with.offset(-30);
        make.width.equalTo(ws.wxRegisterButton);
        make.height.equalTo(ws.wxRegisterButton);
    }];
}


@end
