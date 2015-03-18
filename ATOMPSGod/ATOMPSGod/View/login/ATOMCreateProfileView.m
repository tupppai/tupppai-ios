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

static int padding10 = 10;

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
    [self addSubview:_topBackGroundImageView];
    
    _userHeaderButton = [UIButton new];
    _userHeaderButton.backgroundColor = [UIColor redColor];
    _userHeaderButton.layer.cornerRadius = 36.25;
    _userHeaderButton.layer.masksToBounds = YES;
    [self addSubview:_userHeaderButton];
    
    _changeHeaderLabel = [UILabel new];
    _changeHeaderLabel.textColor = [UIColor colorWithHex:0x606060];
    _changeHeaderLabel.text = @"修改头像";
    [self addSubview:_changeHeaderLabel];
    
    _nicknameView = [UIView new];
    [self setCommonView:_nicknameView];
    
    _sexView = [UIView new];
    [self setCommonView:_sexView];
    
    _areaView = [UIView new];
    [self setCommonView:_areaView];
    
    _protocolView = [UIView new];
    [self setCommonView:_protocolView];
    
    [_topBackGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.mas_top);
        make.width.equalTo(ws.mas_width);
        make.height.equalTo(@156);
    }];
    
    [_userHeaderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.centerY.equalTo(ws.topBackGroundImageView.mas_bottom);
        make.width.equalTo(@72);
        make.height.equalTo(@72);
    }];
    
    [_changeHeaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.userHeaderButton.mas_bottom);
        make.bottom.equalTo(ws.nicknameView.mas_top);
        make.width.equalTo(@72);
    }];
    
    [_nicknameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.topBackGroundImageView.mas_bottom).with.offset(74);
        make.width.equalTo(ws.mas_width);
        make.height.equalTo(@60);
    }];
    
    [_sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.nicknameView.mas_bottom);
        make.width.equalTo(ws.mas_width);
        make.height.equalTo(ws.nicknameView);
    }];
    
    [_areaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.sexView.mas_bottom);
        make.width.equalTo(ws.mas_width);
        make.height.equalTo(ws.nicknameView);
    }];
    
    [_protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.width.equalTo(ws.mas_width);
        make.top.equalTo(ws.areaView.mas_bottom);
        make.bottom.equalTo(ws.mas_bottom);
    }];
    
}

- (void)createNicknameSubView {
    WS(ws);
    _nicknameLabel = [UILabel new];
    _nicknameLabel.text = @"昵称 :";
    _nicknameLabel.textColor = [UIColor colorWithHex:0x606060];
    [_nicknameView addSubview:_nicknameLabel];
    
    [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.nicknameView.mas_left).with.offset(30);
        make.centerY.equalTo(ws.nicknameView.mas_centerY);
        make.width.equalTo(@50);
        make.height.equalTo(ws.nicknameView.mas_height);
    }];
    
    _nicknameTextField = [UITextField new];
    _nicknameTextField.textColor = [UIColor colorWithHex:0x606060];
    _nicknameTextField.returnKeyType = UIReturnKeyDone;
    [_nicknameView addSubview:_nicknameTextField];
    
    [_nicknameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.nicknameLabel.mas_right);
        make.top.equalTo(ws.nicknameView.mas_top);
        make.bottom.equalTo(ws.nicknameView.mas_bottom);
        make.right.equalTo(ws.nicknameView.mas_right).with.offset(-padding10);
    }];
    
}

- (void)createSexSubView {
    WS(ws);
    _sexLabel = [UILabel new];
    _sexLabel.text = @"性别 :";
    _sexLabel.textColor = [UIColor colorWithHex:0x606060];
    [_sexView addSubview:_sexLabel];
    
    [_sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.sexView.mas_left).with.offset(30);
        make.centerY.equalTo(ws.sexView.mas_centerY);
        make.width.equalTo(@50);
        make.height.equalTo(ws.sexView.mas_height);
    }];
    
    _manButton = [UIButton new];
    //默认是男
    _manButton.selected = YES;
    _manButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    _manButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    _manButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_manButton setTitle:@"男" forState:UIControlStateNormal];
    [_manButton setTitleColor:[UIColor colorWithHex:0x606060] forState:UIControlStateNormal];
    [_manButton setImage:[UIImage imageNamed:@"btn_choosen_normal"] forState:UIControlStateNormal];
    [_manButton setImage:[UIImage imageNamed:@"btn_choosen_pressed"] forState:UIControlStateSelected];
    [_manButton setImageEdgeInsets:UIEdgeInsetsMake(8.5, 0, 8.5, 5)];
    [_manButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 5, 7, 0)];
    [_sexView addSubview:_manButton];
    
    [_manButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.sexLabel.mas_right).with.offset(15);
        make.centerY.equalTo(ws.sexLabel.mas_centerY);
        make.height.equalTo(@30);
        make.width.equalTo(@40);
    }];
    
    _womanButton = [UIButton new];
    _womanButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    _womanButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    _womanButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_womanButton setTitle:@"女" forState:UIControlStateNormal];
    [_womanButton setTitleColor:[UIColor colorWithHex:0x606060] forState:UIControlStateNormal];
    [_womanButton setImage:[UIImage imageNamed:@"btn_choosen_normal"] forState:UIControlStateNormal];
    [_womanButton setImage:[UIImage imageNamed:@"btn_choosen_pressed"] forState:UIControlStateSelected];
    [_womanButton setImageEdgeInsets:UIEdgeInsetsMake(8.5, 0, 8.5, 5)];
    [_womanButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 5, 7, 0)];
    [_sexView addSubview:_womanButton];
    
    [_womanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.manButton.mas_right).with.offset(15);
        make.centerY.equalTo(ws.sexLabel.mas_centerY);
        make.height.equalTo(@30);
        make.width.equalTo(@40);
    }];
    
}

- (void)createAreaSubView {
    WS(ws);
    _areaLabel = [UILabel new];
    _areaLabel.text = @"所在地 :";
    _areaLabel.textColor = [UIColor colorWithHex:0x606060];
    [_areaView addSubview:_areaLabel];
    
    [_areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.areaView.mas_left).with.offset(30);
        make.centerY.equalTo(ws.areaView.mas_centerY);
        make.width.equalTo(@70);
        make.height.equalTo(ws.areaView.mas_height);
    }];
}

- (void)setCommonView:(UIView *)view {
    view.backgroundColor = [UIColor colorWithHex:0xededed];
    [self addSubview:view];
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.2];
    [view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.right.equalTo(view.mas_right);
        make.top.equalTo(view.mas_top);
        make.height.equalTo(@0.5);
    }];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.2];
    [view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.right.equalTo(view.mas_right);
        make.bottom.equalTo(view.mas_bottom);
        make.height.equalTo(@0.5);
    }];
}





















@end
