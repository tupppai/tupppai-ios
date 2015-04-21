//
//  ATOMShareView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShareFunctionView.h"

@interface ATOMShareFunctionView ()

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *xlLabel;
@property (nonatomic, strong) UILabel *wxLabel;
@property (nonatomic, strong) UILabel *qqLabel;
@property (nonatomic, strong) UILabel *qqzoneLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *inviteButton;
@property (nonatomic, strong) UIButton *reportButton;
@property (nonatomic, strong) UIButton *collectButton;
@property (nonatomic, strong) UILabel *inviteLabel;
@property (nonatomic, strong) UILabel *reportLabel;
@property (nonatomic, strong) UILabel *collectLabel;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation ATOMShareFunctionView

static int padding25 = 25;
static int buttonWidth = 40;
static int padding35 = 35;
static int padding10 = 10;
static CGFloat BOTTOMHEIGHT = 273;


- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.5];
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    CGFloat labelWidth = buttonWidth + padding10 * 2;
    CGFloat labelHeight = 30;
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - BOTTOMHEIGHT, SCREEN_WIDTH, BOTTOMHEIGHT)];
    _bottomView.backgroundColor = [UIColor colorWithHex:0xededed];
    [self addSubview:_bottomView];
    
    CGFloat buttonInterval = (SCREEN_WIDTH - 2 * padding25 - 4 * buttonWidth) / 3;
    _xlButton = [[UIButton alloc] initWithFrame:CGRectMake(padding25, padding35, buttonWidth, buttonWidth)];
    [_xlButton setBackgroundImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
    [_bottomView addSubview:_xlButton];
    
    _wxButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_xlButton.frame) + buttonInterval, padding35, buttonWidth, buttonWidth)];
    [_wxButton setBackgroundImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
    [_bottomView addSubview:_wxButton];
    
    _qqButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_wxButton.frame) + buttonInterval, padding35, buttonWidth, buttonWidth)];
    [_qqButton setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    [_bottomView addSubview:_qqButton];
    
    _qqzoneButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_qqButton.frame) + buttonInterval, padding35, buttonWidth, buttonWidth)];
    [_qqzoneButton setBackgroundImage:[UIImage imageNamed:@"qqzone"] forState:UIControlStateNormal];
    [_bottomView addSubview:_qqzoneButton];
    
    _xlLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_xlButton.frame) - padding10, CGRectGetMaxY(_xlButton.frame), labelWidth, labelHeight)];
    [self configCommonLabel:_xlLabel WithText:@"新浪微博" AndTextColor:[UIColor colorWithHex:0x666666]];
    
    _wxLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_wxButton.frame) - padding10, CGRectGetMaxY(_wxButton.frame), labelWidth, labelHeight)];
    [self configCommonLabel:_wxLabel WithText:@"微信好友" AndTextColor:[UIColor colorWithHex:0x666666]];
    
    _qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_qqButton.frame) - padding10, CGRectGetMaxY(_qqButton.frame), labelWidth, labelHeight)];
    [self configCommonLabel:_qqLabel WithText:@"QQ好友" AndTextColor:[UIColor colorWithHex:0x666666]];
    
    _qqzoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_qqzoneButton.frame) - padding10, CGRectGetMaxY(_qqzoneButton.frame), labelWidth, labelHeight)];
    [self configCommonLabel:_qqzoneLabel WithText:@"QQ空间" AndTextColor:[UIColor colorWithHex:0x666666]];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 105, SCREEN_WIDTH, 0.5)];
    _lineView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.2];
    [_bottomView addSubview:_lineView];
    
    CGFloat buttonOriginX = CGRectGetMaxX(_xlButton.frame) + buttonInterval / 2 - 20;
    CGFloat buttonOriginY = CGRectGetMaxY(_lineView.frame) + 19;
    buttonInterval = (SCREEN_WIDTH - buttonOriginX * 2 - 3 * buttonWidth) / 2;
    _inviteButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonOriginX, buttonOriginY, buttonWidth, buttonWidth)];
    [_inviteButton setBackgroundImage:[UIImage imageNamed:@"btn_invitation"] forState:UIControlStateNormal];
    [_bottomView addSubview:_inviteButton];
    
    _reportButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_inviteButton.frame) + buttonInterval, buttonOriginY, buttonWidth, buttonWidth)];
    [_reportButton setBackgroundImage:[UIImage imageNamed:@"icon_report"] forState:UIControlStateNormal];
    [_bottomView addSubview:_reportButton];
    
    _collectButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_reportButton.frame) + buttonInterval, buttonOriginY, buttonWidth, buttonWidth)];
    [_collectButton setBackgroundImage:[UIImage imageNamed:@"icon_docollect_"] forState:UIControlStateNormal];
    [_bottomView addSubview:_collectButton];
    
    _inviteLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_inviteButton.frame) - padding10, CGRectGetMaxY(_inviteButton.frame), labelWidth, labelHeight)];
    [self configCommonLabel:_inviteLabel WithText:@"邀请" AndTextColor:[UIColor colorWithHex:0x454545]];
    
    _reportLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_reportButton.frame) - padding10, CGRectGetMaxY(_reportButton.frame), labelWidth, labelHeight)];
    [self configCommonLabel:_reportLabel WithText:@"举报" AndTextColor:[UIColor colorWithHex:0x454545]];
    
    _collectLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_collectButton.frame) - padding10, CGRectGetMaxY(_collectButton.frame), labelWidth, labelHeight)];
    [self configCommonLabel:_collectLabel WithText:@"收藏" AndTextColor:[UIColor colorWithHex:0x454545]];
    
    
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGHeight(_bottomView.frame) - 17 - 43, SCREEN_WIDTH - 20 * 2, 43)];
    _cancelButton.backgroundColor = [UIColor colorWithHex:0x858c96];
    _cancelButton.layer.cornerRadius = 5;
    _cancelButton.layer.masksToBounds = YES;
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomView addSubview:_cancelButton];
    [_cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)configCommonLabel:(UILabel *)label WithText:(NSString *)text AndTextColor:(UIColor *)textColor {
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.f];
    [_bottomView addSubview:label];
}

- (void)clickCancelButton:(UIButton *)sender {
    [self removeFromSuperview];
}


























@end
