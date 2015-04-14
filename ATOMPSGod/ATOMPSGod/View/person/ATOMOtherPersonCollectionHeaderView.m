//
//  ATOMOtherPersonCollectionHeaderView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/17.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMOtherPersonCollectionHeaderView.h"

@implementation ATOMOtherPersonCollectionHeaderView

static int padding = 10;
static int padding3 = 3;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    [self createTopBackGroundImageView];
    [self createCenterView];
}

- (void)createTopBackGroundImageView {
    _topBackGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 156)];
    _topBackGroundImageView.userInteractionEnabled = YES;
    _topBackGroundImageView.image = [UIImage imageNamed:@"header_bg"];
    [self addSubview:_topBackGroundImageView];
    
    _userHeaderButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 72) / 2, padding, 72, 72)];
    [_userHeaderButton setBackgroundImage:[UIImage imageNamed:@"head_portrait"] forState:UIControlStateNormal];
    _userHeaderButton.layer.cornerRadius = 36;
    _userHeaderButton.layer.masksToBounds = YES;
    [_topBackGroundImageView addSubview:_userHeaderButton];
    
    _userSexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - SEXRADIUS, CGRectGetMaxY(_userHeaderButton.frame) - SEXRADIUS, SEXRADIUS, SEXRADIUS)];
    _userSexImageView.image = [UIImage imageNamed:@"woman"];
    _userSexImageView.layer.cornerRadius = 8.5;
    _userSexImageView.layer.masksToBounds = YES;
    [_topBackGroundImageView addSubview:_userSexImageView];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 6;
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.f], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    CGFloat buttonWidth = 72;
    
    _attentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_userHeaderButton.frame) - buttonWidth, CGRectGetMaxY(_userHeaderButton.frame) + padding, buttonWidth, 40)];
    _attentionLabel.userInteractionEnabled = YES;
    _attentionLabel.numberOfLines = 0;
    NSAttributedString *attentionLabelText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"关注\n123"] attributes:attributeDict];
    _attentionLabel.attributedText = attentionLabelText;
    _attentionLabel.textAlignment = NSTextAlignmentCenter;
    [_topBackGroundImageView addSubview:_attentionLabel];
    
    _fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_userHeaderButton.frame), CGRectGetMaxY(_userHeaderButton.frame) + padding, buttonWidth, 40)];
    _fansLabel.userInteractionEnabled = YES;
    _fansLabel.numberOfLines = 0;
    NSAttributedString *fansLabelText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"粉丝\n123"] attributes:attributeDict];
    _fansLabel.attributedText = fansLabelText;
    _fansLabel.textAlignment = NSTextAlignmentCenter;
    [_topBackGroundImageView addSubview:_fansLabel];
    
    _praiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame), CGRectGetMaxY(_userHeaderButton.frame) + padding, buttonWidth, 40)];
    _praiseLabel.numberOfLines = 0;
    NSAttributedString *praiseLabelText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"赞\n123"] attributes:attributeDict];
    _praiseLabel.attributedText = praiseLabelText;
    _praiseLabel.textAlignment = NSTextAlignmentCenter;
    [_topBackGroundImageView addSubview:_praiseLabel];
    
    _attentionButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 45, CGRectGetMaxY(_userHeaderButton.frame) - 20, 45, 20)];
    _attentionButton.backgroundColor = [UIColor colorWithHex:0xfcc64a];
    [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    [_attentionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_topBackGroundImageView addSubview:_attentionButton];
}

- (void)createCenterView {
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 156, SCREEN_WIDTH, 44)];
    _centerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_centerView];
    
    _otherPersonUploadButton = [[UIButton alloc] initWithFrame:CGRectMake(padding, padding3 * 2, SCREEN_WIDTH / 2 - 2 * padding, 44 - padding3 * 4)];
    [_otherPersonUploadButton setImage:[UIImage imageNamed:@"btn_psask_normal"] forState:UIControlStateNormal];
    [_otherPersonUploadButton setImage:[UIImage imageNamed:@"btn_psask_pressed"] forState:UIControlStateSelected];
    [_centerView addSubview:_otherPersonUploadButton];
    
    _otherPersonWorkButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + padding, padding3 * 2, CGWidth(_otherPersonUploadButton.frame), CGHeight(_otherPersonUploadButton.frame))];
    [_otherPersonWorkButton setImage:[UIImage imageNamed:@"btn_pswork_normal"] forState:UIControlStateNormal];
    [_otherPersonWorkButton setImage:[UIImage imageNamed:@"btn_pswork_pressed"] forState:UIControlStateSelected];
    [_centerView addSubview:_otherPersonWorkButton];
    
    _blueThinView = [UIView new];
    _blueThinView.backgroundColor = [UIColor colorWithHex:0x00adef];
    [_centerView addSubview:_blueThinView];
    
}

































@end
