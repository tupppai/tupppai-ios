//
//  ATOMCreateProfileView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIECreateProfileView.h"
;

@interface PIECreateProfileView ()
@property (nonatomic, strong) UIView *nicknameView;
@property (nonatomic, strong) UIView *protocolView;
@property (nonatomic, strong) UIView *sexPickerTopView;
@property (nonatomic, strong) UIView *regionPickerTopView;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UIImageView *maskImageView;

@end

@implementation PIECreateProfileView

- (instancetype)init {
    self = [super init];
    if (self) {
        _genderIsMan = YES;
        [self createSubView];
        [self createTopViewSubView];
        [self createNameSubView];
        [self createAreaSubView];
        [self createRegionPickerView];
        [self createProtocolSubView];
    }
    return self;
}




- (void)createSubView {
    WS(ws);
    //top
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_topView];

    _nicknameView = [UIView new];
    [self addSubview:_nicknameView];
    
    _areaView = [UIView new];
    [self addSubview:_areaView];
    
    
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(self).with.offset(NAV_HEIGHT);
        make.width.equalTo(ws.mas_width);
        make.height.equalTo(@200);
    }];
    
    [_nicknameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.topView.mas_bottom);
        make.left.equalTo(ws.mas_left).with.offset(kPadding30);
        make.right.equalTo(ws.mas_right).with.offset(-kPadding30);
        make.height.equalTo(@50);
    }];
    
    [_areaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.nicknameView.mas_bottom).with.offset(5);
        make.width.equalTo(ws.nicknameView);
        make.height.equalTo(ws.nicknameView);
    }];

}



- (void)createAreaSubView {
    WS(ws);
    _areaLabel = [UILabel new];
    _areaLabel.text = @"所在地:";
    _areaLabel.textColor = [UIColor colorWithHex:0x606060];
    _areaLabel.font = [UIFont systemFontOfSize:15];
    [_areaView addSubview:_areaLabel];
    [_areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.areaView.mas_left);
        make.centerY.equalTo(ws.areaView.mas_centerY);
        make.width.equalTo(@70);
        make.height.equalTo(ws.areaView.mas_height);
    }];
    
    _showAreaLabel = [UILabel new];
    _showAreaLabel.text = @"";
    _showAreaLabel.font = [UIFont systemFontOfSize:15];

    _showAreaLabel.textAlignment = NSTextAlignmentLeft;
    _showAreaLabel.textColor = [UIColor colorWithHex:0x606060];
    [_areaView addSubview:_showAreaLabel];
    
    [_showAreaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.areaLabel.mas_right);
        make.right.equalTo(ws.areaView.mas_right).with.offset(-25);
        make.centerY.equalTo(ws.areaLabel.mas_centerY);
        make.height.equalTo(ws.areaLabel.mas_height);
    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    arrowImageView.contentMode = UIViewContentModeCenter;
    arrowImageView.image = [UIImage imageNamed:@"ic_right-arrow"];
    [_areaView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_areaView.mas_right).with.offset(-kPadding5);
        make.centerY.equalTo(_areaView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(11, 24));
    }];
    
    UIView* line = [UIView new];
    line.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.1];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.areaView.mas_bottom).with.offset(2);
        make.centerX.equalTo(_areaView);
        make.width.equalTo(self.areaView);
        make.height.equalTo(@1);
    }];
}

- (void)createProtocolSubView {

//
    _protocolLabel = [UILabel new];
    _protocolLabel.text = @"点击下一步表示同意";
    
    _protocolLabel.textAlignment = NSTextAlignmentCenter;
    _protocolLabel.font = [UIFont systemFontOfSize:kFont14];
    _protocolLabel.userInteractionEnabled = YES;
//    [self addSubview:_protocolLabel];
    [self insertSubview:_protocolLabel atIndex:0];

    [_protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_areaView.mas_bottom).with.offset(kPadding30);
        make.centerX.equalTo(self).with.offset(-50);
//        make.height.equalTo(@14);
//        make.width.equalTo(ws.protocolView);
    }];
    
    _protocolButton = [UIButton new];
    _protocolButton.titleLabel.font = [UIFont systemFontOfSize:kFont14];
    [_protocolButton setTitleColor:[UIColor colorWithHex:0x74c3ff] forState:UIControlStateNormal];
    [_protocolButton setTitle:@"用户协议" forState:UIControlStateNormal];
    [self insertSubview:_protocolButton atIndex:1];
//    
    [_protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_protocolLabel);
        make.left.equalTo(_protocolLabel.mas_right).with.offset(2);
//        make.width.equalTo(@50);
    }];
}


- (void)createRegionPickerView {
    WS(ws);
    _regionPickerBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _regionPickerBackgroundView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer* tapToDismiss = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideRegionPickerView)];
    [_regionPickerBackgroundView addGestureRecognizer:tapToDismiss];
    [self addSubview:_regionPickerBackgroundView];

    _regionPickerView.tag = 222;
    _regionPickerView = [UIPickerView new];
    _regionPickerView.backgroundColor = [UIColor whiteColor];
    _regionPickerView.alpha = 1.0;
    [_regionPickerBackgroundView addSubview:_regionPickerView];
    
    _regionPickerTopView = [UIView new];
    _regionPickerTopView.layer.borderWidth = 0.5;
    _regionPickerTopView.layer.borderColor = [UIColor colorWithHex:0x737373 andAlpha:0.8].CGColor;
    _regionPickerTopView.backgroundColor = [UIColor whiteColor];
    [_regionPickerBackgroundView addSubview:_regionPickerTopView];
    
    _cancelRegionPickerButton = [UIButton new];
    [_cancelRegionPickerButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelRegionPickerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _confirmRegionPickerButton = [UIButton new];
    [_confirmRegionPickerButton setTitle:@"完成" forState:UIControlStateNormal];
    [_confirmRegionPickerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_regionPickerTopView addSubview:_cancelRegionPickerButton];
    [_regionPickerTopView addSubview:_confirmRegionPickerButton];
    
    [_regionPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_regionPickerBackgroundView);
        make.right.equalTo(_regionPickerBackgroundView);
        make.bottom.equalTo(_regionPickerBackgroundView);
        make.height.mas_equalTo(@300);
    }];
    
    [_regionPickerTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.regionPickerView);
        make.right.equalTo(ws.regionPickerView);
        make.height.equalTo(@40);
        make.bottom.equalTo(ws.regionPickerView.mas_top);
    }];
//    _regionPickerView.backgroundColor = [UIColor lightGrayColor];
    
    [_cancelRegionPickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.regionPickerTopView.mas_left);
        make.right.equalTo(ws.confirmRegionPickerButton.mas_left);
        make.height.equalTo(@40);
        make.top.equalTo(ws.regionPickerTopView.mas_top);
    }];
    
    [_confirmRegionPickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.regionPickerTopView.mas_right);
        make.width.equalTo(ws.cancelRegionPickerButton.mas_width);
        make.height.equalTo(@40);
        make.top.equalTo(ws.regionPickerTopView.mas_top);
    }];
}

//- (void)addSubviewWithLine:(UIView *)view {
//    [self addSubview:view];
//    UIView *lineView = [UIView new];
//    lineView.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.2];
//    [view addSubview:lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(view.mas_left);
//        make.right.equalTo(view.mas_right);
//        make.top.equalTo(view.mas_top);
//        make.height.equalTo(@0.5);
//    }];
//}


- (void)createNameSubView {
    WS(ws);
    
    [_nicknameView addSubview:self.nicknameTextField];
    [_nicknameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.nicknameView.mas_top);
        make.bottom.equalTo(ws.nicknameView.mas_bottom);
        make.left.equalTo(ws.nicknameView);
        make.right.equalTo(ws.nicknameView);
    }];
    
    UIView* line = [UIView new];
    line.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.1];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameView.mas_bottom).with.offset(2);
        make.centerX.equalTo(_nicknameView);
        make.width.equalTo(self.nicknameView);
        make.height.equalTo(@1);
    }];

}

- (void)createTopViewSubView {
    WS(ws);
    [self.topView addSubview:self.userHeaderButton];
    [self.topView addSubview:self.sexSegment];
    
    [_userHeaderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.topView.mas_top).with.offset(kPadding30);
        make.width.equalTo(@74);
        make.height.equalTo(@74);
    }];
    [_maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws.userHeaderButton);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    [self.sexSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.userHeaderButton.mas_bottom).with.offset(5);
        make.width.equalTo(@150);
        make.height.equalTo(@50);
    }];
}

- (void)showRegionPickerView {
    [UIView animateWithDuration:0.2 animations:^{
        _regionPickerBackgroundView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

- (void)hideRegionPickerView {
    [UIView animateWithDuration:0.2 animations:^{
        _regionPickerBackgroundView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

-(UIButton *)userHeaderButton {
    if (!_userHeaderButton) {
        _userHeaderButton = [UIButton new];
        _userHeaderButton.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.1];
        _userHeaderButton.layer.cornerRadius = kUserBigHeaderButtonWidth / 2;
        _userHeaderButton.clipsToBounds = YES;
        _maskImageView = [UIImageView new];
        _maskImageView.image =  [UIImage imageNamed:@"login_profile_mask"];
        _maskImageView.backgroundColor = [UIColor clearColor];
        _maskImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_userHeaderButton addSubview:_maskImageView];
    }
    return _userHeaderButton;
}
- (HMSegmentedControl*)sexSegment {
    if (!_sexSegment) {
        NSArray* array = [NSArray arrayWithObjects:[UIImage imageNamed:@"createprofile_gender_male"],[UIImage imageNamed:@"createprofile_gender_female"], nil];
        NSArray* arraySelected = [NSArray arrayWithObjects:[UIImage imageNamed:@"createprofile_gender_male_selected"],[UIImage imageNamed:@"createprofile_gender_female_selected"], nil];
        _sexSegment = [[HMSegmentedControl alloc] initWithSectionImages:array sectionSelectedImages:arraySelected];
        _sexSegment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        [_sexSegment setIndexChangeBlock:^(NSInteger index) {
            if (index == 0) {
                _genderIsMan = YES;
            } else {
                _genderIsMan = NO;
            }
        }];
    }
    return _sexSegment;
}


-(UITextField *)nicknameTextField {
    if (!_nicknameTextField) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 60, 25) ];
        [lbl setText:@"昵称:"];
        [lbl setTextColor:[UIColor colorWithHex:0x606060]];
        [lbl setTextAlignment:NSTextAlignmentLeft];
        lbl.font = [UIFont systemFontOfSize:15];
        _nicknameTextField = [UITextField new];
        _nicknameTextField.textColor = [UIColor colorWithHex:0x737373];
        _nicknameTextField.returnKeyType = UIReturnKeyDone;
        _nicknameTextField.placeholder = @"点击输入";
        _nicknameTextField.leftView = lbl;
        _nicknameTextField.leftViewMode = UITextFieldViewModeAlways;
        _nicknameTextField.font = [UIFont systemFontOfSize:15];

    }
    return _nicknameTextField;
}


@end
