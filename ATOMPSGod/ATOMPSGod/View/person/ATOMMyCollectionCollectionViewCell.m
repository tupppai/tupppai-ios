//
//  ATOMMyCollectionCollectionViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyCollectionCollectionViewCell.h"

@interface ATOMMyCollectionCollectionViewCell ()

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat imageViewHeight;

@end

@implementation ATOMMyCollectionCollectionViewCell

static int padding6 = 6;
static int padding10 = 10;
static int collumnNumber = 2;

- (CGFloat)cellWidth {
    if (!_cellWidth) {
        _cellWidth = (SCREEN_WIDTH - (collumnNumber - 1) * padding6) / collumnNumber;
        _cellHeight = _cellWidth + 50;
        _imageViewHeight = _cellWidth;
    }
    return _cellWidth;
}

- (UIImageView *)collectionImageView {
    if (!_collectionImageView) {
        _collectionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.cellWidth, self.imageViewHeight)];
        _collectionImageView.backgroundColor = [UIColor whiteColor];
        _collectionImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_collectionImageView];
    }
    return _collectionImageView;
}

- (UIButton *)userHeaderButton {
    if (!_userHeaderButton) {
        _userHeaderButton = [[UIButton alloc] initWithFrame:CGRectMake(padding10, padding10, 30, 30)];
        _userHeaderButton.backgroundColor = [UIColor orangeColor];
        _userHeaderButton.layer.cornerRadius = 14.5;
        _userHeaderButton.layer.masksToBounds = YES;
        [self addSubview:_userHeaderButton];
    }
    return _userHeaderButton;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userHeaderButton.frame) + padding10, padding10, 80, 30)];
        _userNameLabel.textColor = [UIColor colorWithHex:0x838383];
        [self addSubview:_userNameLabel];
    }
    return _userNameLabel;
}

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    self.userNameLabel.text = _userName;
}

- (void)setCollectionImage:(UIImage *)collectionImage {
    _collectionImage = collectionImage;
    self.collectionImageView.image = _collectionImage;
}

@end
