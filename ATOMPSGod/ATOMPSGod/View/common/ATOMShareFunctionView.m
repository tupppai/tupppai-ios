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
@property (nonatomic, strong) UILabel *wxFriendCircleLabel;
@property (nonatomic, strong) UILabel *wxLabel;
@property (nonatomic, strong) UILabel *sinaWeiboLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *inviteButton;
@property (nonatomic, strong) UIButton *reportButton;
@property (nonatomic, strong) UILabel *inviteLabel;
@property (nonatomic, strong) UILabel *reportLabel;
@property (nonatomic, strong) UILabel *collectLabel;
@end

@implementation ATOMShareFunctionView

static CGFloat BOTTOMHEIGHT = 286;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.0];
        self.hidden = true;
        [self createSubView];
        [self configClickEvent];
    }
    return self;
}
- (void)createSubView {
    CGFloat labelWidth = kShareButtonWidth + kPadding10 * 2;
    CGFloat labelHeight = 30;
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(kPadding5, CGRectGetMaxY(self.frame), SCREEN_WIDTH - 2 * kPadding5, BOTTOMHEIGHT)];
    
    _bottomView.layer.cornerRadius = 5;
    _bottomView.backgroundColor = [UIColor colorWithHex:0xededed];
    [self addSubview:_bottomView];
    
    CGFloat buttonInterval = (CGWidth(_bottomView.frame) - 3 * kShareButtonWidth) / 4;

    _wxButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonInterval, kPadding10, kShareButtonWidth, kShareButtonWidth)];
    [_wxButton setBackgroundImage:[UIImage imageNamed:@"wechat_big"] forState:UIControlStateNormal];
    [_bottomView addSubview:_wxButton];
    
    _wxFriendCircleButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonInterval + CGRectGetMaxX(_wxButton.frame), CGOriginY(_wxButton.frame), kShareButtonWidth, kShareButtonWidth)];
    [_wxFriendCircleButton setBackgroundImage:[UIImage imageNamed:@"moment_big"] forState:UIControlStateNormal];
    [_bottomView addSubview:_wxFriendCircleButton];
    
    _sinaWeiboButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonInterval + CGRectGetMaxX(_wxFriendCircleButton.frame), CGOriginY(_wxButton.frame), kShareButtonWidth, kShareButtonWidth)];
    [_sinaWeiboButton setBackgroundImage:[UIImage imageNamed:@"weibo_big"] forState:UIControlStateNormal];
    [_bottomView addSubview:_sinaWeiboButton];
    
    _wxLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_wxButton.frame) - kPadding10, CGRectGetMaxY(_wxButton.frame), labelWidth, labelHeight)];
    [self configCommonLabel:_wxLabel WithText:@"微信好友" AndTextColor:[UIColor colorWithHex:0xacb8c1]];
    
    _wxFriendCircleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_wxFriendCircleButton.frame) - kPadding10, CGRectGetMaxY(_wxFriendCircleButton.frame), labelWidth, labelHeight)];
    [self configCommonLabel:_wxFriendCircleLabel WithText:@"微信朋友圈" AndTextColor:[UIColor colorWithHex:0xacb8c1]];
    
    _sinaWeiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_sinaWeiboButton.frame) - kPadding10, CGRectGetMaxY(_sinaWeiboButton.frame), labelWidth, labelHeight)];
    [self configCommonLabel:_sinaWeiboLabel WithText:@"新浪微博" AndTextColor:[UIColor colorWithHex:0xacb8c1]];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_wxFriendCircleLabel.frame) + kPadding5, CGWidth(_bottomView.frame), 0.5)];
    _lineView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.2];
    [_bottomView addSubview:_lineView];
    
    CGFloat buttonOriginY = CGRectGetMaxY(_lineView.frame) + 19;
    buttonInterval = (CGWidth(_bottomView.frame) - kShareButtonWidth * 3) / 4;
    _inviteButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonInterval, buttonOriginY, kShareButtonWidth, kShareButtonWidth)];
    [_inviteButton setBackgroundImage:[UIImage imageNamed:@"invite"] forState:UIControlStateNormal];
    [_bottomView addSubview:_inviteButton];
    
    _collectButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_inviteButton.frame) + buttonInterval, buttonOriginY, kShareButtonWidth, kShareButtonWidth)];
    [_collectButton setBackgroundImage:[UIImage imageNamed:@"ic_collect"] forState:UIControlStateNormal];
    [_collectButton setBackgroundImage:[UIImage imageNamed:@"ic_collect_selected"] forState:UIControlStateSelected];
    [_bottomView addSubview:_collectButton];
    
    _reportButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_collectButton.frame) + buttonInterval, buttonOriginY, kShareButtonWidth, kShareButtonWidth)];
    [_reportButton setBackgroundImage:[UIImage imageNamed:@"report"] forState:UIControlStateNormal];
    [_bottomView addSubview:_reportButton];
    
    _inviteLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_inviteButton.frame) - kPadding10, CGRectGetMaxY(_inviteButton.frame), labelWidth, labelHeight)];
    [self configCommonLabel:_inviteLabel WithText:@"邀请" AndTextColor:[UIColor colorWithHex:0xacb8c1]];
    
    _collectLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_collectButton.frame) - kPadding10, CGRectGetMaxY(_collectButton.frame), labelWidth, labelHeight)];
    [self configCommonLabel:_collectLabel WithText:@"收藏" AndTextColor:[UIColor colorWithHex:0xacb8c1]];
    
    _reportLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_reportButton.frame) - kPadding10, CGRectGetMaxY(_reportButton.frame), labelWidth, labelHeight)];
    [self configCommonLabel:_reportLabel WithText:@"举报" AndTextColor:[UIColor colorWithHex:0xacb8c1]];
    
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGHeight(_bottomView.frame) - 17 - 43, CGWidth(_bottomView.frame) - 20 * 2, 43)];
    _cancelButton.backgroundColor = [UIColor colorWithHex:0xbdc7ce];
    _cancelButton.layer.cornerRadius = 43 / 2;
    _cancelButton.layer.masksToBounds = YES;
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomView addSubview:_cancelButton];
    [_cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)configClickEvent {
    [self.wxButton addTarget:self action:@selector(tapWechatFriendsShareButton) forControlEvents:UIControlEventTouchUpInside];
    [self.wxFriendCircleButton addTarget:self action:@selector(tapWechatMomentShareButton) forControlEvents:UIControlEventTouchUpInside];
    [self.sinaWeiboButton addTarget:self action:@selector(tapSinaWeiboShareButton) forControlEvents:UIControlEventTouchUpInside];
    [self.inviteButton addTarget:self action:@selector(tapInviteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.collectButton addTarget:self action:@selector(tapCollectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.reportButton addTarget:self action:@selector(tapReportButton) forControlEvents:UIControlEventTouchUpInside];
}
-(void)tapWechatFriendsShareButton {
    if (_delegate && [_delegate respondsToSelector:@selector(tapWechatFriends)]) {
        [_delegate tapWechatFriends];
    }
}
-(void)tapWechatMomentShareButton {
    if (_delegate && [_delegate respondsToSelector:@selector(tapWechatMoment)]) {
        [_delegate tapWechatMoment];
    }
}
-(void)tapSinaWeiboShareButton {
    if (_delegate && [_delegate respondsToSelector:@selector(tapSinaWeibo)]) {
        [_delegate tapSinaWeibo];
    }
}
-(void)tapInviteButton {
    [self dismiss];
    if (_delegate && [_delegate respondsToSelector:@selector(tapInvite)]) {
        [_delegate tapInvite];
    }
}
-(void)tapCollectButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(tapCollect)]) {
        [_delegate tapCollect];
    }
}
-(void)tapReportButton {
    if (_delegate && [_delegate respondsToSelector:@selector(tapReport)]) {
        [_delegate tapReport];
    }
}
- (void)configCommonLabel:(UILabel *)label WithText:(NSString *)text AndTextColor:(UIColor *)textColor {
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.f];
    [_bottomView addSubview:label];
}
-(void)dismiss {
    [UIView animateWithDuration:0.35 animations:^{
        _bottomView.frame = CGRectMake(kPadding5, CGRectGetMaxY(self.frame), SCREEN_WIDTH - 2 * kPadding5, BOTTOMHEIGHT);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
-(void)show {
    [UIView animateWithDuration:0.35 animations:^{
        self.hidden = false;
        _bottomView.frame = CGRectMake(kPadding5, CGRectGetMaxY(self.frame)-BOTTOMHEIGHT, SCREEN_WIDTH - 2 * kPadding5, BOTTOMHEIGHT);
    } completion:^(BOOL finished) {
    }];
}
- (void)clickCancelButton:(UIButton *)sender {
    [self dismiss];
}


























@end
