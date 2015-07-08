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
//    [_topView showPlaceHolder];
    _topView.userInteractionEnabled = YES;
    _topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_topView];
    
    _userHeaderButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 94) / 2, kPadding15, 94, 94)];
    _userHeaderButton.layer.cornerRadius = 94 / 2;
    _userHeaderButton.layer.masksToBounds = YES;
    _userHeaderButton.layer.borderColor = [UIColor colorWithHex:0x74c3ff].CGColor;
    _userHeaderButton.layer.borderWidth = 4;
    [_userHeaderButton setBackgroundImage:[UIImage imageNamed:@"head_portrait"] forState:UIControlStateNormal];
    [_topView addSubview:_userHeaderButton];
    
    _userSexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - 27 / 2, _userHeaderButton.center.y - 27 / 2, 27, 27)];
    _userSexImageView.image = [UIImage imageNamed:@"gender_female"];
    [_topView addSubview:_userSexImageView];
    
    NSString *str = @"123";
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 6;
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:kFont14], NSFontAttributeName, [UIColor colorWithHex:0x74c3ff], NSForegroundColorAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    CGFloat buttonWidth = 60;
    CGFloat buttonHeight = 40;
    CGFloat buttonInterval = (94 - buttonWidth) / 2;
    CGFloat buttonOriginY = CGRectGetMaxY(_userHeaderButton.frame) + kPadding15;
    _attentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_userHeaderButton.frame) - buttonInterval - buttonWidth, buttonOriginY, buttonWidth, buttonHeight)];
//    _attentionLabel.backgroundColor = [UIColor orangeColor];
    _attentionLabel.userInteractionEnabled = YES;
    _attentionLabel.numberOfLines = 0;
    NSMutableAttributedString *attentionStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d\n关注", 123] attributes:attributeDict];
    [attentionStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, [UIColor colorWithHex:0xc3cbd2], NSForegroundColorAttributeName, nil] range:NSMakeRange(str.length + 1, 2)];
    _attentionLabel.attributedText = attentionStr;
    _attentionLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_attentionLabel];
    
    _fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userHeaderButton.center.x - buttonWidth / 2, buttonOriginY, buttonWidth, buttonHeight)];
    _fansLabel.userInteractionEnabled = YES;
    _fansLabel.numberOfLines = 0;
    NSMutableAttributedString *fansStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d\n粉丝", 123] attributes:attributeDict];
    [fansStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, [UIColor colorWithHex:0xc3cbd2], NSForegroundColorAttributeName, nil] range:NSMakeRange(str.length + 1, 2)];
    _fansLabel.attributedText = fansStr;
    _fansLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_fansLabel];
    
    _praiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + buttonInterval, buttonOriginY, buttonWidth, buttonHeight)];
    _praiseLabel.userInteractionEnabled = YES;
    _praiseLabel.numberOfLines = 0;
    NSMutableAttributedString *praiseStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d\n赞", 123] attributes:attributeDict];
    [praiseStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, [UIColor colorWithHex:0xc3cbd2], NSForegroundColorAttributeName, nil] range:NSMakeRange(str.length + 1, 1)];
    _praiseLabel.attributedText = praiseStr;
    _praiseLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_praiseLabel];
    
    _attentionButton = [[UIButton alloc] initWithFrame:CGRectMake(_userHeaderButton.center.x - 50, CGRectGetMaxY(_fansLabel.frame) + kPadding15, 100, kPadding30)];
    [_attentionButton setBackgroundImage:[UIImage imageNamed:@"btn_add_focus"] forState:UIControlStateNormal];
    [_attentionButton setBackgroundImage:[UIImage imageNamed:@"btn_focus"] forState:UIControlStateSelected];
    [_topView addSubview:_attentionButton];
}

- (void)createCenterView {
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 256, SCREEN_WIDTH, 44)];
    _centerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_centerView];

    _otherPersonUploadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, 44 - kPadding5)];
    [_otherPersonUploadButton setTitle:@"求P（5）" forState:UIControlStateNormal];
    [_otherPersonUploadButton setTitleColor:[UIColor colorWithHex:0xacbbc1] forState:UIControlStateNormal];
    [_otherPersonUploadButton setTitleColor:[UIColor colorWithHex:0x74c3ff] forState:UIControlStateSelected];
    [_centerView addSubview:_otherPersonUploadButton];
    
    _otherPersonWorkButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, 44 - kPadding5)];
    [_otherPersonWorkButton setTitle:@"作品（5）" forState:UIControlStateNormal];
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
