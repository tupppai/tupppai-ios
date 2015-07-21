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
@property (nonatomic, strong) UIView *protocolView;
@property (nonatomic, strong) UIView *sexPickerTopView;
@property (nonatomic, strong) UIView *regionPickerTopView;

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
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_topView];
    
    _userHeaderButton = [UIButton new];
    [_userHeaderButton setBackgroundImage:[UIImage imageNamed:@"head_portrait"] forState:UIControlStateNormal];
    _userHeaderButton.layer.cornerRadius = kUserBigHeaderButtonWidth / 2;
    _userHeaderButton.layer.masksToBounds = YES;
    [_topView addSubview:_userHeaderButton];
    
    _changeHeaderLabel = [UILabel new];
    _changeHeaderLabel.textColor = [UIColor lightGrayColor];
    _changeHeaderLabel.text = @"选择头像";
    _changeHeaderLabel.font = [UIFont systemFontOfSize:kFont14];
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
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.mas_top);
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
    _nicknameLabel.text = @"昵称 :";
    _nicknameLabel.textColor = [UIColor colorWithHex:0x606060];
    [_nicknameView addSubview:_nicknameLabel];
    
    [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.nicknameView.mas_left);
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
        make.left.equalTo(ws.sexView.mas_left);
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
        make.left.equalTo(ws.areaView.mas_left);
        make.centerY.equalTo(ws.areaView.mas_centerY);
        make.width.equalTo(@70);
        make.height.equalTo(ws.areaView.mas_height);
    }];
    
    _showAreaLabel = [UILabel new];
    _showAreaLabel.text = @"";
    _showAreaLabel.textColor = [UIColor colorWithHex:0x606060];
    [_areaView addSubview:_showAreaLabel];
    
    [_showAreaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.areaLabel.mas_right);
        make.right.equalTo(ws.areaView.mas_right);
        make.centerY.equalTo(ws.areaLabel.mas_centerY);
        make.height.equalTo(ws.areaLabel.mas_height);
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
    _sexPickerView.tag = 111;
    _sexPickerView = [UIPickerView new];
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
        make.height.equalTo(@150);
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
        make.height.equalTo(@40);
        make.top.equalTo(ws.sexPickerTopView.mas_top).with.offset(padding10);
    }];
    
    [_confirmPickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.sexPickerTopView.mas_right).with.offset(-padding10);
        make.width.equalTo(@50);
        make.height.equalTo(@40);
        make.top.equalTo(ws.sexPickerTopView.mas_top).with.offset(padding10);
    }];
}

- (void)createRegionPickerView {
    WS(ws);
    _regionPickerView.tag = 222;
    _regionPickerView = [UIPickerView new];
    _regionPickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_regionPickerView];
    
    _regionPickerTopView = [UIView new];
    _regionPickerTopView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_regionPickerTopView];
    
    _cancelRegionPickerButton = [UIButton new];
    [_cancelRegionPickerButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelRegionPickerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _confirmRegionPickerButton = [UIButton new];
    [_confirmRegionPickerButton setTitle:@"完成" forState:UIControlStateNormal];
    [_confirmRegionPickerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_regionPickerTopView addSubview:_cancelRegionPickerButton];
    [_regionPickerTopView addSubview:_confirmRegionPickerButton];
    
    [_regionPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws);
        make.left.equalTo(ws);
        make.right.equalTo(ws);
        make.height.equalTo(@200);
    }];
    
    [_regionPickerTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.regionPickerView);
        make.right.equalTo(ws.regionPickerView);
        make.bottom.equalTo(ws.regionPickerView.mas_top);
        make.height.equalTo(@60);
    }];
    
    [_cancelRegionPickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.regionPickerTopView.mas_left).with.offset(padding10);
        make.width.equalTo(@50);
        make.height.equalTo(@40);
        make.top.equalTo(ws.regionPickerTopView.mas_top).with.offset(padding10);
    }];
    
    [_confirmRegionPickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.regionPickerTopView.mas_right).with.offset(-padding10);
        make.width.equalTo(@50);
        make.height.equalTo(@40);
        make.top.equalTo(ws.regionPickerTopView.mas_top).with.offset(padding10);
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
    _sexPickerView.hidden = NO;
    _sexPickerTopView.hidden = NO;
}

- (void)hideSexPickerView {
    _sexPickerView.hidden = YES;
    _sexPickerTopView.hidden = YES;
}

- (void)showRegionPickerView {
    _regionPickerTopView.hidden = NO;
    _regionPickerView.hidden = NO;
}

- (void)hideRegionPickerView {
    _regionPickerTopView.hidden = YES;
    _regionPickerView.hidden = YES;
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
