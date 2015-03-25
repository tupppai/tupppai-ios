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
@property (nonatomic, strong) UIButton *wxButton;
@property (nonatomic, strong) UIButton *xlButton;
@property (nonatomic, strong) UIButton *qqButton;
@property (nonatomic, strong) UIButton *qqzoneButton;
@property (nonatomic, strong) UILabel *xlLabel;
@property (nonatomic, strong) UILabel *wxLabel;
@property (nonatomic, strong) UILabel *qqLabel;
@property (nonatomic, strong) UILabel *qqzoneLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *inviteButton;
@property (nonatomic, strong) UIButton *reportButton;
@property (nonatomic, strong) UIButton *collectButton;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation ATOMShareFunctionView

static int padding25 = 25;
static int buttonWidth = 40;
static int padding35 = 35;
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
    
    CGFloat labelWidth = SCREEN_WIDTH / 4;
    CGFloat labelHeight = 30;
    _xlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_xlButton.frame), labelWidth, labelHeight)];
    [self configCommonLabel:_xlLabel WithText:@"新浪微博" AndTextColor:[UIColor colorWithHex:0x666666]];
    
    _wxLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, CGRectGetMaxY(_wxButton.frame), labelWidth, labelHeight)];
    [self configCommonLabel:_wxLabel WithText:@"微信好友" AndTextColor:[UIColor colorWithHex:0x666666]];
    
    _qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth * 2, CGRectGetMaxY(_qqButton.frame), labelWidth, labelHeight)];
    [self configCommonLabel:_qqLabel WithText:@"QQ好友" AndTextColor:[UIColor colorWithHex:0x666666]];
    
    _qqzoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth * 3, CGRectGetMaxY(_qqzoneButton.frame), labelWidth, labelHeight)];
    [self configCommonLabel:_qqzoneLabel WithText:@"QQ空间" AndTextColor:[UIColor colorWithHex:0x666666]];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 105, SCREEN_WIDTH, 0.5)];
    _lineView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.2];
    [_bottomView addSubview:_lineView];
    
//    _cancelButton = [UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_bottomView.frame) - 17 - , <#CGFloat width#>, <#CGFloat height#>)
    
}

- (void)configCommonLabel:(UILabel *)label WithText:(NSString *)text AndTextColor:(UIColor *)textColor {
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:label];
}































@end
