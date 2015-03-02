//
//  ATOMCreateProfileView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCreateProfileView.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface ATOMCreateProfileView ()

@property (nonatomic, strong) UILabel *changeHeaderLabel;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *sexLabel;
@property (nonatomic, strong) UILabel *areaLabel;

@property (nonatomic, strong) UIView *nicknameView;
@property (nonatomic, strong) UIView *sexView;
@property (nonatomic, strong) UIView *areaView;
@property (nonatomic, strong) UIView *protocolView;

@end

@implementation ATOMCreateProfileView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubView];
        [self createNicknameSubView];
        [self createSexSubView];
        [self createAreaSubView];
    }
    return self;
}

- (void)createSubView {
    WS(ws);
    _topBackGroundImageView = [UIImageView new];
    _topBackGroundImageView.backgroundColor = [UIColor orangeColor];
    [_topBackGroundImageView showPlaceHolder];
    [self addSubview:_topBackGroundImageView];
    
    _userHeaderButton = [UIButton new];
    _userHeaderButton.layer.cornerRadius = 36.25;
    _userHeaderButton.layer.masksToBounds = YES;
    _userHeaderButton.backgroundColor = [UIColor redColor];
    [_userHeaderButton showPlaceHolder];
    [self addSubview:_userHeaderButton];
    
    _changeHeaderLabel = [UILabel new];
    _changeHeaderLabel.backgroundColor = [UIColor redColor];
    _changeHeaderLabel.text = @"修改头像";
    [_changeHeaderLabel showPlaceHolder];
    [self addSubview:_changeHeaderLabel];
    
    _nicknameView = [UIView new];
    _nicknameView.layer.borderWidth = 1;
    _nicknameView.backgroundColor = [UIColor colorWithHex:0xededed];
    [_nicknameView showPlaceHolder];
    [self addSubview:_nicknameView];
    
    _sexView = [UIView new];
    _sexView.layer.borderWidth = 1;
    _sexView.backgroundColor = [UIColor colorWithHex:0xededed];
    [_sexView showPlaceHolder];
    [self addSubview:_sexView];
    
    _areaView = [UIView new];
    _areaView.layer.borderWidth = 1;
    _areaView.backgroundColor = [UIColor colorWithHex:0xededed];
    [_areaView showPlaceHolder];
    [self addSubview:_areaView];
    
    _protocolView = [UIView new];
    _protocolView.layer.borderWidth = 1;
    _protocolView.backgroundColor = [UIColor colorWithHex:0xededed];
    [_protocolView showPlaceHolder];
    [self addSubview:_protocolView];
    
    [_topBackGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.mas_top);
        make.width.equalTo(ws.mas_width);
        make.height.equalTo(@156.5);
    }];
    
    [_userHeaderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.centerY.equalTo(ws.topBackGroundImageView.mas_bottom);
        make.width.equalTo(@72.5);
        make.height.equalTo(@72.5);
    }];
    
    [_changeHeaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.userHeaderButton.mas_bottom);
        make.bottom.equalTo(ws.nicknameView.mas_top);
        make.width.equalTo(@72.5);
    }];
    
    [_nicknameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.topBackGroundImageView.mas_bottom).with.offset(74);
        make.width.equalTo(ws.mas_width);
        make.height.equalTo(ws.sexView.mas_height);
    }];
    
    [_sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.nicknameView.mas_bottom);
        make.width.equalTo(ws.mas_width);
        make.height.equalTo(ws.areaView.mas_height);
    }];
    
    [_areaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.sexView.mas_bottom);
        make.width.equalTo(ws.mas_width);
        make.height.equalTo(@62.5);
    }];
    
    [_protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.areaView.mas_bottom);
        make.width.equalTo(ws.mas_width);
        make.bottom.equalTo(ws.mas_bottom);
    }];
    
}

- (void)createNicknameSubView {
    WS(ws);
    _nicknameLabel = [UILabel new];
    _nicknameLabel.text = @"昵称 :";
    _nicknameLabel.backgroundColor = [UIColor yellowColor];
    [_nicknameView addSubview:_nicknameLabel];
    
    [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.nicknameView.mas_left).with.offset(30);
        make.centerY.equalTo(ws.nicknameView.mas_centerY);
        make.width.equalTo(@50);
        make.height.equalTo(ws.nicknameView.mas_height);
    }];
    
}

- (void)createSexSubView {
    WS(ws);
    _sexLabel = [UILabel new];
    _sexLabel.text = @"性别 :";
    _sexLabel.backgroundColor = [UIColor yellowColor];
    [_sexView addSubview:_sexLabel];
    
    [_sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.sexView.mas_left).with.offset(30);
        make.centerY.equalTo(ws.sexView.mas_centerY);
        make.width.equalTo(@50);
        make.height.equalTo(ws.sexView.mas_height);
    }];
}

- (void)createAreaSubView {
    WS(ws);
    _areaLabel = [UILabel new];
    _areaLabel.text = @"所在地 :";
    _areaLabel.backgroundColor = [UIColor yellowColor];
    [_areaView addSubview:_areaLabel];
    
    [_areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.areaView.mas_left).with.offset(30);
        make.centerY.equalTo(ws.areaView.mas_centerY);
        make.width.equalTo(@70);
        make.height.equalTo(ws.areaView.mas_height);
    }];
}








@end
