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
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        self.layer.contents = (id)[UIImage imageNamed:@"ps_bg.jpg"].CGImage;
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
    [_loginButton setTitle:@"已有账号登陆>" forState:UIControlStateNormal];
    
    _wxRegisterButton.backgroundColor = [UIColor colorWithHex:0x00aeff];
    [_wxRegisterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _otherRegisterButton.backgroundColor = [UIColor colorWithHex:0xffffff];
    [_otherRegisterButton setTitleColor:[UIColor colorWithHex:0x6f6f6f] forState:UIControlStateNormal];
    
    [self addSubview:_wxRegisterButton];
    [self addSubview:_otherRegisterButton];
    [self addSubview:_loginButton];
    
    [_wxRegisterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left);
        make.bottom.equalTo(ws.mas_bottom).with.offset(-45);
        make.width.equalTo(ws.otherRegisterButton.mas_width);
        make.right.equalTo(ws.otherRegisterButton.mas_left);
        make.height.equalTo(@45);
    }];
    
    [_otherRegisterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.mas_right);
        make.bottom.equalTo(ws.wxRegisterButton.mas_bottom);
        make.width.equalTo(ws.wxRegisterButton);
        make.left.equalTo(ws.wxRegisterButton.mas_right);
        make.height.equalTo(ws.wxRegisterButton);
    }];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.bottom.equalTo(ws.mas_bottom);
        make.width.equalTo(ws.wxRegisterButton);
        make.top.equalTo(ws.wxRegisterButton.mas_bottom);
    }];
}


@end
