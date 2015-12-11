//
//  PIEModifySelf.m
//  TUPAI
//
//  Created by chenpeiwei on 10/10/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//
;

#import "PIEModifySelfView.h"
@interface PIEModifySelfView()
@property (nonatomic, strong) UIView *nicknameView;
@property (nonatomic, strong) UIView *protocolView;
@property (nonatomic, strong) UIView *sexPickerTopView;
@property (nonatomic, strong) UIView *regionPickerTopView;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UIImageView *maskImageView;

@end

@implementation PIEModifySelfView

- (instancetype)init {
    self = [super init];
    if (self) {
        _genderIsMan = YES;
        [self createSubView];
        [self createTopViewSubView];
        [self createNameSubView];
//        [self createAreaSubView];
//        [self createRegionPickerView];
        [self createProtocolSubView];
        [self injectSource];
    }
    return self;
}

- (void)injectSource {
    [self.userHeaderButton setImageForState:UIControlStateNormal withURL:[[NSURL alloc]initWithString:[DDUserManager currentUser].avatar]];
    self.nicknameTextField.text = [DDUserManager currentUser].nickname;
    NSInteger index = [DDUserManager currentUser].sex ? 0:1;
    [self.sexSegment setSelectedSegmentIndex:index];
}
- (void)createSubView {
    WS(ws);
    //top
    self.backgroundColor = [UIColor whiteColor];
    _topView = [UIView new];
    [self addSubview:_topView];
    
    _nicknameView = [UIView new];
    [self addSubview:_nicknameView];
    
//    _areaView = [UIView new];
//    [self addSubviewWithLine:_areaView];
    
    _protocolView = [UIView new];
    [self addSubviewWithLine:_protocolView];
    
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
        make.height.equalTo(@60);
    }];
    
//    [_areaView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(ws.mas_centerX);
//        make.top.equalTo(ws.nicknameView.mas_bottom);
//        make.width.equalTo(ws.nicknameView);
//        make.height.equalTo(ws.nicknameView);
//    }];
//    
    [_protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.width.equalTo(ws.nicknameView);
        make.bottom.equalTo(ws.nicknameView.mas_bottom);
    }];
    
}

- (void)createNameSubView {
    WS(ws);
    
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 60, 25) ];
    [lbl setText:@"昵称:"];
    [lbl setTextColor:[UIColor colorWithHex:0x606060]];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    
    _nicknameTextField = [UITextField new];
    _nicknameTextField.textColor = [UIColor colorWithHex:0x737373];
    _nicknameTextField.returnKeyType = UIReturnKeyDone;
    _nicknameTextField.placeholder = @"点击输入";
    _nicknameTextField.leftView = lbl;
    _nicknameTextField.leftViewMode = UITextFieldViewModeAlways;
    [_nicknameView addSubview:_nicknameTextField];
    
    [_nicknameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.nicknameView.mas_top);
        make.bottom.equalTo(ws.nicknameView.mas_bottom);
        make.left.equalTo(ws.nicknameView);
        make.right.equalTo(ws.nicknameView);
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

- (void)createAreaSubView {
    WS(ws);
    _areaLabel = [UILabel new];
    _areaLabel.text = @"所在地:";
    _areaLabel.textColor = [UIColor colorWithHex:0x606060];
    [_areaView addSubview:_areaLabel];
    [_areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.areaView.mas_left);
        make.centerY.equalTo(ws.areaView.mas_centerY);
        make.width.equalTo(@70);
        make.height.equalTo(ws.areaView.mas_height);
    }];
    
    _showAreaLabel = [UILabel new];
    _showAreaLabel.text = @"";
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
}

- (void)createProtocolSubView {
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont14], NSFontAttributeName, [UIColor colorWithHex:0x74c3ff], NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"点击下一步表示同意用户协议" attributes:attributeDict];
    [str addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont14], NSFontAttributeName, [UIColor colorWithHex:0xacbbc1], NSForegroundColorAttributeName, nil] range:NSMakeRange(0, 9)];
//    WS(ws);
//    _protocolLabel = [UILabel new];
//    _protocolLabel.attributedText = str;
//    _protocolLabel.textAlignment = NSTextAlignmentCenter;
//    [_protocolView addSubview:_protocolLabel];
    
//    [_protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(ws.protocolView.mas_bottom).with.offset(kPadding30);
//        make.centerX.equalTo(ws.protocolView.mas_centerX);
//        make.height.equalTo(@14);
//        make.width.equalTo(ws.protocolView);
//    }];
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
        make.height.mas_equalTo(@(SCREEN_HEIGHT/2));
    }];
    
    [_regionPickerTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.regionPickerView);
        make.right.equalTo(ws.regionPickerView);
        make.height.equalTo(@40);
        make.bottom.equalTo(ws.regionPickerView.mas_top);
    }];
    
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

- (void)addSubviewWithLine:(UIView *)view {
    [self addSubview:view];
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.2];
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.right.equalTo(view.mas_right);
        make.top.equalTo(view.mas_top);
        make.height.equalTo(@0.5);
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
@end
