//
//  ATOMOtherPersonCollectionHeaderView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/17.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMOtherPersonCollectionHeaderView.h"

@interface ATOMOtherPersonCollectionHeaderView ()

@property (nonatomic, strong) UIView *thinVerticalView1;
@property (nonatomic, strong) UIView *thinVerticalView2;

@end

@implementation ATOMOtherPersonCollectionHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 300);
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    [self createTopBackGroundImageView];
    [self createCenterView];
}

- (void)createTopBackGroundImageView {
    _topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 256)];
    _topView.userInteractionEnabled = YES;
    _topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_topView];
    
    _userHeaderButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 94) / 2, kPadding15, 94, 94)];
    _userHeaderButton.layer.cornerRadius = 94 / 2;
    _userHeaderButton.layer.masksToBounds = YES;
    _userHeaderButton.layer.borderColor = [UIColor colorWithHex:0x74c3ff].CGColor;
    _userHeaderButton.layer.borderWidth = 4;
    _userHeaderButton.userInteractionEnabled = NO;
    [_userHeaderButton setBackgroundImage:[UIImage imageNamed:@"head_portrait"] forState:UIControlStateNormal];
    [_topView addSubview:_userHeaderButton];
    
    _userSexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - 27 / 2, _userHeaderButton.center.y - 27 / 2, 27, 27)];
    _userSexImageView.image = [UIImage imageNamed:@"gender_male"];
    [_topView addSubview:_userSexImageView];
    
    NSString *str = @"*";
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 6;
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17], NSFontAttributeName, [UIColor colorWithHex:0x74c3ff], NSForegroundColorAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    CGFloat buttonWidth = 90;
    CGFloat buttonHeight = 43;
    CGFloat buttonInterval = 0;
    CGFloat buttonOriginY = CGRectGetMaxY(_userHeaderButton.frame) + kPadding15;


    
    _fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userHeaderButton.center.x - buttonWidth / 2, buttonOriginY, buttonWidth, buttonHeight)];
    _fansLabel.userInteractionEnabled = YES;
    _fansLabel.numberOfLines = 0;
    NSMutableAttributedString *fansStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n粉丝", str] attributes:attributeDict];
    [fansStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont12], NSFontAttributeName, [UIColor colorWithHex:0xc3cbd2], NSForegroundColorAttributeName, nil] range:NSMakeRange(str.length + 1, 2)];
    _fansLabel.attributedText = fansStr;
    _fansLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_fansLabel];
    
    CALayer *Border2 = [CALayer layer];
    Border2.frame = CGRectMake(_fansLabel.frame.size.width, 5 , 1.0, buttonHeight-10);
    Border2.backgroundColor = [UIColor colorWithHex:0xc6c6c6 andAlpha:0.8].CGColor;
    [_fansLabel.layer addSublayer:Border2];
    
    
    _attentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_fansLabel.frame) - buttonInterval - buttonWidth, buttonOriginY, buttonWidth, buttonHeight)];
    _attentionLabel.userInteractionEnabled = YES;
    _attentionLabel.numberOfLines = 0;
    NSMutableAttributedString *attentionStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n关注", str] attributes:attributeDict];
    [attentionStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont12], NSFontAttributeName, [UIColor colorWithHex:0xc3cbd2], NSForegroundColorAttributeName, nil] range:NSMakeRange(str.length + 1, 2)];
    _attentionLabel.attributedText = attentionStr;
    _attentionLabel.textAlignment = NSTextAlignmentCenter;
    
    [_topView addSubview:_attentionLabel];
    
    CALayer *Border1 = [CALayer layer];
    Border1.frame = CGRectMake(_attentionLabel.frame.size.width, 5 , 1.0, buttonHeight-10);
    Border1.backgroundColor = [UIColor colorWithHex:0xc6c6c6 andAlpha:0.8].CGColor;
    [_attentionLabel.layer addSublayer:Border1];
    
    
    _praiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_fansLabel.frame) + buttonInterval, buttonOriginY, buttonWidth, buttonHeight)];
    _praiseLabel.userInteractionEnabled = YES;
    _praiseLabel.numberOfLines = 0;
    NSMutableAttributedString *praiseStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n赞", str] attributes:attributeDict];
    [praiseStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont12], NSFontAttributeName, [UIColor colorWithHex:0xc3cbd2], NSForegroundColorAttributeName, nil] range:NSMakeRange(str.length + 1, 1)];
    _praiseLabel.attributedText = praiseStr;
    _praiseLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_praiseLabel];
    
    _attentionButton = [[UIButton alloc] initWithFrame:CGRectMake(_userHeaderButton.center.x - 50, CGRectGetMaxY(_fansLabel.frame) + kPadding20, 100, kPadding35+4)];
    [_attentionButton setImage:[UIImage imageNamed:@"btn_add_focus"] forState:UIControlStateNormal];
    [_attentionButton setImage:[UIImage imageNamed:@"btn_focus"] forState:UIControlStateHighlighted];
    [_attentionButton setImage:[UIImage imageNamed:@"btn_focus"] forState:UIControlStateSelected];
    [_topView addSubview:_attentionButton];

}

- (void)createCenterView {
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 256, SCREEN_WIDTH, 44)];
    _centerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_centerView];

    _otherPersonUploadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, 44 - kPadding5)];
    [_otherPersonUploadButton setTitle:@"求P（*）" forState:UIControlStateNormal];
    [_otherPersonUploadButton setTitleColor:[UIColor colorWithHex:0xacbbc1] forState:UIControlStateNormal];
    [_otherPersonUploadButton setTitleColor:[UIColor colorWithHex:0x74c3ff] forState:UIControlStateSelected];
    [_centerView addSubview:_otherPersonUploadButton];
    
    _otherPersonWorkButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, 44 - kPadding5)];
    [_otherPersonWorkButton setTitle:@"作品（*）" forState:UIControlStateNormal];
    [_otherPersonWorkButton setTitleColor:[UIColor colorWithHex:0xacbbc1] forState:UIControlStateNormal];
    [_otherPersonWorkButton setTitleColor:[UIColor colorWithHex:0x74c3ff] forState:UIControlStateSelected];
    [_centerView addSubview:_otherPersonWorkButton];
    
    _blueThinView = [UIView new];
    _blueThinView.backgroundColor = [UIColor colorWithHex:0x74c3ff];
    [_centerView addSubview:_blueThinView];
    
    _grayThinView = [UIView new];
    _grayThinView.backgroundColor = [UIColor colorWithHex:0xacbbc1];
    [_centerView addSubview:_grayThinView];
    [self toggleSegmentBar:0];
}

-(void)toggleSegmentBar:(int)type {
    if (type == 0) {
        _blueThinView.frame = CGRectMake(0, CGRectGetMaxY(self.otherPersonUploadButton.frame), SCREEN_WIDTH / 2, kPadding5);
        _grayThinView.frame = CGRectMake(SCREEN_WIDTH / 2, CGRectGetMaxY(self.otherPersonUploadButton.frame) + 3, SCREEN_WIDTH / 2, kPadding5 / 2);
        _otherPersonUploadButton.selected = YES;
        _otherPersonWorkButton.selected = NO;
    } else if (type == 1) {
        _blueThinView.frame = CGRectMake(SCREEN_WIDTH / 2, CGRectGetMaxY(self.otherPersonWorkButton.frame), SCREEN_WIDTH / 2, kPadding5);
        _grayThinView.frame = CGRectMake(0, CGRectGetMaxY(self.otherPersonWorkButton.frame) + 3, SCREEN_WIDTH / 2, kPadding5 / 2);
        _otherPersonUploadButton.selected = NO;
        _otherPersonWorkButton.selected = YES;

    }

}







@end
