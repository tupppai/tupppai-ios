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
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *sexLabel;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UIView *nicknameView;
@property (nonatomic, strong) UIView *protocolView;
@property (nonatomic, strong) UIView *sexPickerTopView;
@property (nonatomic, strong) UIView *regionPickerTopView;

@end

@implementation ATOMCreateProfileView

//static int padding10 = 10;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubView];
        [self createNicknameSubView];
        [self createSexSubView];
        [self createAreaSubView];
        [self createProtocolSubView];
        [self createSexPickerView];
        [self hideSexPickerView];
        [self createRegionPickerView];
        [self hideRegionPickerView];
    }
    return self;
}

- (void)createSubView {
    WS(ws);
    _backButton = [UIButton new];
    [_backButton setImage:[UIImage imageNamed:@"icon_back_login"] forState:UIControlStateNormal];
    [self addSubview:_backButton];
    
    UILabel *backButtonLabel = [UILabel new];
    backButtonLabel.text = @"其它方式注册";
    backButtonLabel.textColor = [UIColor colorWithHex:0x637685];
    backButtonLabel.font = [UIFont systemFontOfSize:18.0];
    [self addSubview:backButtonLabel];
    
    _nextButton = [UIButton new];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor colorWithHex:0x637685] forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor colorWithHex:0x637685 andAlpha:0.1] forState:UIControlStateHighlighted];

    [self addSubview:_nextButton];

    _topView = [UIView new];
    _topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_topView];
    
    _userHeaderButton = [UIButton new];
    [_userHeaderButton setBackgroundImage:[UIImage imageNamed:@"head_portrait"] forState:UIControlStateNormal];
    _userHeaderButton.layer.cornerRadius = kUserBigHeaderButtonWidth / 2;
    _userHeaderButton.layer.masksToBounds = YES;
    [_topView addSubview:_userHeaderButton];
    
    _changeHeaderLabel = [UILabel new];
    _changeHeaderLabel.textColor = [UIColor colorWithHex:0x7fc7ff];
    _changeHeaderLabel.text = @"选择头像";
    _changeHeaderLabel.font = [UIFont systemFontOfSize:kFont14];
    _changeHeaderLabel.userInteractionEnabled = YES;
    _changeHeaderLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_changeHeaderLabel];
    
    _nicknameView = [UIView new];
    [self setCommonView:_nicknameView];
    
    _sexView = [UIView new];
    [self setCommonView:_sexView];
    
    _areaView = [UIView new];
    [self setCommonView:_areaView];
    
    _protocolView = [UIView new];
    [self setCommonView:_protocolView];
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left).with.offset(kPadding15);
        make.top.equalTo(ws.mas_top).with.offset(kPadding30);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    [backButtonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.centerY.equalTo(_backButton.mas_centerY);
        make.height.equalTo(@40);
    }];
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.mas_right).with.offset(-kPadding15);
        make.centerY.equalTo(_backButton.mas_centerY);
        make.height.equalTo(@40);
    }];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(_backButton.mas_bottom);
        make.width.equalTo(ws.mas_width);
        make.height.equalTo(@150);
    }];
    
    [_userHeaderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.topView.mas_top).with.offset(kPadding30);
        make.width.equalTo(@74);
        make.height.equalTo(@74);
    }];
    
    [_changeHeaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.userHeaderButton.mas_bottom).with.offset(kPadding10);
        make.width.equalTo(@74);
        make.height.equalTo(@14);
    }];
    
    [_nicknameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.topView.mas_bottom);
        make.left.equalTo(ws.mas_left).with.offset(kPadding30);
        make.right.equalTo(ws.mas_right).with.offset(-kPadding30);
        make.height.equalTo(@60);
    }];
    
    [_sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.nicknameView.mas_bottom);
        make.width.equalTo(ws.nicknameView);
        make.height.equalTo(ws.nicknameView);
    }];
    
    [_areaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.sexView.mas_bottom);
        make.width.equalTo(ws.nicknameView);
        make.height.equalTo(ws.nicknameView);
    }];
    
    [_protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.width.equalTo(ws.nicknameView);
        make.top.equalTo(ws.areaView.mas_bottom);
        make.bottom.equalTo(ws.mas_bottom);
    }];
    
}

- (void)createNicknameSubView {
    WS(ws);
    _nicknameLabel = [UILabel new];
    _nicknameLabel.text = @"昵称";
    _nicknameLabel.textColor = [UIColor colorWithHex:0x737373];
    [_nicknameView addSubview:_nicknameLabel];
    
    [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.nicknameView.mas_left);
        make.centerY.equalTo(ws.nicknameView.mas_centerY);
        make.width.equalTo(@50);
        make.height.equalTo(ws.nicknameView.mas_height);
    }];
    
    _nicknameTextField = [UITextField new];
    _nicknameTextField.textColor = [UIColor colorWithHex:0x737373];
    _nicknameTextField.returnKeyType = UIReturnKeyDone;
    _nicknameTextField.textAlignment = NSTextAlignmentRight;
    _nicknameTextField.placeholder = @"惹不起的PS大神";
    [_nicknameView addSubview:_nicknameTextField];
    
    [_nicknameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.nicknameView.mas_top);
        make.bottom.equalTo(ws.nicknameView.mas_bottom);
        make.left.equalTo(ws.nicknameLabel.mas_right);
        make.right.equalTo(ws.nicknameView.mas_right).with.offset(-25);
    }];
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    arrowImageView.contentMode = UIViewContentModeCenter;
    arrowImageView.image = [UIImage imageNamed:@"ic_right-arrow"];
    [_nicknameView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_nicknameView.mas_right).with.offset(-kPadding5);
        make.centerY.equalTo(_nicknameView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(11, 24));
    }];
}

- (void)createSexSubView {
    WS(ws);
    _sexLabel = [UILabel new];
    _sexLabel.text = @"性别";
    _sexLabel.textColor = [UIColor colorWithHex:0x606060];
    [_sexView addSubview:_sexLabel];
    
    [_sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.sexView.mas_left);
        make.centerY.equalTo(ws.sexView.mas_centerY);
        make.width.equalTo(@50);
        make.height.equalTo(ws.sexView.mas_height);
    }];
    
    _showSexLabel = [UILabel new];
    _showSexLabel.text = @"";
    _showSexLabel.textColor = [UIColor colorWithHex:0x606060];
    _showSexLabel.textAlignment = NSTextAlignmentRight;
    [_sexView addSubview:_showSexLabel];
    
    [_showSexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.sexLabel.mas_right);
        make.centerY.equalTo(ws.sexLabel.mas_centerY);
        make.height.equalTo(ws.sexLabel.mas_height);
        make.left.equalTo(ws.sexLabel.mas_right);
        make.right.equalTo(ws.sexView.mas_right).with.offset(-45);
    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    arrowImageView.contentMode = UIViewContentModeCenter;
    arrowImageView.image = [UIImage imageNamed:@"ic_right-arrow"];
    [_sexView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_sexView.mas_right).with.offset(-kPadding5);
        make.centerY.equalTo(_sexView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(11, 24));
    }];

}

- (void)createAreaSubView {
    WS(ws);
    _areaLabel = [UILabel new];
    _areaLabel.text = @"所在地";
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
    _showAreaLabel.textAlignment = NSTextAlignmentRight;
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
    WS(ws);
    _protocolLabel = [UILabel new];
    _protocolLabel.attributedText = str;
    _protocolLabel.textAlignment = NSTextAlignmentCenter;
    [_protocolView addSubview:_protocolLabel];
    
    [_protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.protocolView.mas_bottom).with.offset(kPadding30);
        make.centerX.equalTo(ws.protocolView.mas_centerX);
        make.height.equalTo(@14);
        make.width.equalTo(ws.protocolView);
    }];
}

- (void)createSexPickerView {
    WS(ws);
    _sexPickerBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _sexPickerBackgroundView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.8];
    [self addSubview:_sexPickerBackgroundView];
    _sexPickerView.tag = 111;
    _sexPickerView = [UIPickerView new];
    _sexPickerView.backgroundColor = [UIColor whiteColor];
    [_sexPickerBackgroundView addSubview:_sexPickerView];
    
    _sexPickerTopView = [UIView new];
    _sexPickerTopView.backgroundColor = [UIColor whiteColor];
    _sexPickerTopView.layer.borderWidth = 0.5;
    _sexPickerTopView.layer.borderColor = [UIColor colorWithHex:0x737373 andAlpha:0.8].CGColor;

    [_sexPickerBackgroundView addSubview:_sexPickerTopView];
    
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
//        make.height.equalTo(@250);
    }];
    
    [_sexPickerTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.sexPickerView);
        make.right.equalTo(ws.sexPickerView);
        make.bottom.equalTo(ws.sexPickerView.mas_top);
        make.height.equalTo(@40);
    }];
    
    [_cancelPickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.sexPickerTopView.mas_left);
        make.right.equalTo(ws.confirmPickerButton.mas_left);
        make.height.equalTo(@40);
        make.top.equalTo(ws.sexPickerTopView.mas_top);
    }];
    
    [_confirmPickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.sexPickerTopView.mas_right);
        make.width.equalTo(ws.cancelPickerButton.mas_width);
        make.height.equalTo(@40);
        make.top.equalTo(ws.sexPickerTopView.mas_top);
    }];
}

- (void)createRegionPickerView {
    WS(ws);
    _regionPickerBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _regionPickerBackgroundView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.8];
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
        make.left.equalTo(ws);
        make.right.equalTo(ws);
        make.bottom.equalTo(ws);
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

- (void)setCommonView:(UIView *)view {
    view.backgroundColor = [UIColor whiteColor];
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
}

- (void)showSexPickerView {
    _sexPickerBackgroundView.hidden = NO;
}

- (void)hideSexPickerView {
    _sexPickerBackgroundView.hidden = YES;
}

- (void)showRegionPickerView {
    _regionPickerBackgroundView.hidden = NO;
}

- (void)hideRegionPickerView {
    _regionPickerBackgroundView.hidden = YES;
}

- (NSInteger)tagOfCurrentSex {
    if ([_showSexLabel.text isEqualToString:@"男"]) {
        return 1;
    } else if ([_showSexLabel.text isEqualToString:@"女"]) {
        return 0;
    }
    return -1;
}



@end
