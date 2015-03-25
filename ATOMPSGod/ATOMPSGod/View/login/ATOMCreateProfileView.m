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
@property (nonatomic, strong) UIView *areaView;
@property (nonatomic, strong) UIView *protocolView;
@property (nonatomic, strong) UIView *sexPickerTopView;


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
        [self createSexPickerView];
        [self hideSexPickerView];
    }
    return self;
}

- (void)createSubView {
    WS(ws);
    _topBackGroundImageView = [UIImageView new];
    _topBackGroundImageView.image = [UIImage imageNamed:@"header_bg"];
    [self addSubview:_topBackGroundImageView];
    
    _userHeaderButton = [UIButton new];
    [_userHeaderButton setBackgroundImage:[UIImage imageNamed:@"head_portrait"] forState:UIControlStateNormal];
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
    
    _showSexLabel = [UILabel new];
    _showSexLabel.text = @"";
    _showSexLabel.textColor = [UIColor colorWithHex:0x606060];
    [_sexView addSubview:_showSexLabel];
    
    [_showSexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.sexLabel.mas_right);
        make.centerY.equalTo(ws.sexLabel.mas_centerY);
        make.width.equalTo(ws.sexLabel.mas_width);
        make.height.equalTo(ws.sexLabel.mas_height);
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

- (void)createSexPickerView {
    WS(ws);
    _sexPickerView = [UIPickerView new];
//    _sexPickerView.showsSelectionIndicator = YES;
    _sexPickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_sexPickerView];
    
    _sexPickerTopView = [UIView new];
    _sexPickerTopView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_sexPickerTopView];
    
    _cancelPickerButton = [UIButton new];
    [_cancelPickerButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelPickerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _confirmPickerButton = [UIButton new];
    [_confirmPickerButton setTitle:@"完成" forState:UIControlStateNormal];
    [_confirmPickerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_sexPickerTopView addSubview:_cancelPickerButton];
    [_sexPickerTopView addSubview:_confirmPickerButton];
    
    [_sexPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws);
        make.right.equalTo(ws);
        make.bottom.equalTo(ws);
        make.height.equalTo(@90);
    }];
    
    [_sexPickerTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.sexPickerView);
        make.right.equalTo(ws.sexPickerView);
        make.bottom.equalTo(ws.sexPickerView.mas_top);
        make.height.equalTo(@60);
    }];
    
    [_cancelPickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.sexPickerTopView.mas_left).with.offset(padding10);
        make.width.equalTo(@50);
        make.height.equalTo(@25);
        make.top.equalTo(ws.sexPickerTopView.mas_top).with.offset(padding10);
    }];
    
    [_confirmPickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.sexPickerTopView.mas_right).with.offset(-padding10);
        make.width.equalTo(@50);
        make.height.equalTo(@25);
        make.top.equalTo(ws.sexPickerTopView.mas_top).with.offset(padding10);
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

- (void)showSexPickerView {
    _sexPickerView.hidden = NO;
    _sexPickerTopView.hidden = NO;
}

- (void)hideSexPickerView {
    _sexPickerView.hidden = YES;
    _sexPickerTopView.hidden = YES;
}

- (NSInteger)tagOfCurrentSex {
    if ([_showSexLabel.text isEqualToString:@"男"]) {
        return 0;
    } else if ([_showSexLabel.text isEqualToString:@"女"]) {
        return 1;
    }
    return -1;
}
















@end
