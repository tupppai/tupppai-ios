//
//  ATOMOtherPersonView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMOtherPersonView.h"

@interface ATOMOtherPersonView ()

@end

@implementation ATOMOtherPersonView

static int padding = 10;
static int padding3 = 3;

static int padding6 = 6;
static float cellWidth;
static float cellHeight = 150;
static int collumnNumber = 3;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_HEIGHT);
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    [self createTopBackGroundImageView];
    [self createCenterView];
    [self createBottomView];
}

- (void)createTopBackGroundImageView {
    _topBackGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 156)];
    _topBackGroundImageView.userInteractionEnabled = YES;
    _topBackGroundImageView.backgroundColor = [UIColor orangeColor];
    [self addSubview:_topBackGroundImageView];
    
    _userHeaderButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 72) / 2, padding, 72, 72)];
    _userHeaderButton.backgroundColor = [UIColor greenColor];
    _userHeaderButton.layer.cornerRadius = 36;
    _userHeaderButton.layer.masksToBounds = YES;
    [_topBackGroundImageView addSubview:_userHeaderButton];
    
    _userSexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - 17, CGRectGetMaxY(_userHeaderButton.frame) - 17, 17, 17)];
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
    _attentionButton.backgroundColor = [UIColor greenColor];
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

- (void)createBottomView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 200)];
    [self addSubview:_bottomView];
    
    cellWidth = (SCREEN_WIDTH - (collumnNumber + 1) *padding6) / 3;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize =CGSizeMake(cellWidth, cellHeight);
    flowLayout.minimumInteritemSpacing = padding6;
    flowLayout.minimumLineSpacing = padding6;
    _otherPersonUploadCollectionView = [[UICollectionView alloc] initWithFrame:CGRectInset(_bottomView.frame, padding6, padding6) collectionViewLayout:flowLayout];
    _otherPersonUploadCollectionView.backgroundColor = [UIColor whiteColor];
    
    _otherPersonWorkCollectionView = [[UICollectionView alloc] initWithFrame:CGRectInset(_bottomView.frame, padding6, padding6) collectionViewLayout:flowLayout];
    _otherPersonWorkCollectionView.backgroundColor = [UIColor whiteColor];
}

- (void)changeBottomViewToUploadView {
    if (!_otherPersonUploadButton.selected) {
        _otherPersonUploadButton.selected = YES;
        _otherPersonWorkButton.selected = NO;
        _blueThinView.frame = CGRectMake(CGRectGetMinX(_otherPersonUploadButton.frame), CGRectGetMaxY(_otherPersonUploadButton.frame), CGWidth(_otherPersonUploadButton.frame), padding3);
        [_otherPersonWorkCollectionView removeFromSuperview];
        [self addSubview:_otherPersonUploadCollectionView];
    }
}

- (void)changeBottomViewToWorkView {
    if (!_otherPersonWorkButton.selected) {
        _otherPersonWorkButton.selected = YES;
        _otherPersonUploadButton.selected = NO;
        _blueThinView.frame = CGRectMake(CGRectGetMinX(_otherPersonWorkButton.frame), CGRectGetMaxY(_otherPersonWorkButton.frame), CGWidth(_otherPersonWorkButton.frame), padding3);
        [_otherPersonUploadCollectionView removeFromSuperview];
        [self addSubview:_otherPersonWorkCollectionView];
    }
}


























@end
