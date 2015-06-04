//
//  ATOMLaunchView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMLaunchView.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface ATOMLaunchView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ATOMLaunchView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        self.layer.contents = (id)[UIImage imageNamed:@"ps_bg"].CGImage;
        [self updateSubView];
    }
    return self;
}

- (void)updateSubView {
    WS(ws);
    _imageView = [UIImageView new];
    _wxRegisterButton = [UIButton new];
    _otherRegisterButton = [UIButton new];
    _loginButton = [UIButton new];
    
    _imageView.image = [UIImage imageNamed:@"ps_logo"];
    [_wxRegisterButton setBackgroundImage:[UIImage imageNamed:@"btn_wx_register"] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"btn_login"] forState:UIControlStateNormal];
    [_otherRegisterButton setTitle:@"其他方式注册" forState:UIControlStateNormal];
    [_otherRegisterButton setTitleColor:[UIColor colorWithHex:0x74c3ff] forState:UIControlStateNormal];
    _otherRegisterButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    
    [self addSubview:_imageView];
    [self addSubview:_wxRegisterButton];
    [self addSubview:_loginButton];
    [self addSubview:_otherRegisterButton];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(@90);
        make.height.equalTo(@90);
        make.top.equalTo(self).with.offset(120);
    }];
    
    [_wxRegisterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(@180);
        make.height.equalTo(@42);
        make.bottom.equalTo(self.loginButton.mas_top).with.offset(-7);
    }];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(@180);
//        make.top.equalTo(self.wxRegisterButton.mas_bottom).with.offset(7);
        make.height.equalTo(self.wxRegisterButton.mas_height);
        make.bottom.equalTo(self.otherRegisterButton.mas_top).with.offset(-kPadding10);
    }];
    
    [_otherRegisterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
//        make.top.equalTo(ws.loginButton.mas_bottom).with.offset(kPadding10);
        make.bottom.equalTo(ws.mas_bottom).with.offset(-kPadding25);
    }];
}


@end
