//
//  ATOMMyCollectionCollectionViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyCollectionCollectionViewCell.h"
#import "ATOMCollectionViewModel.h"

@interface ATOMMyCollectionCollectionViewCell ()

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation ATOMMyCollectionCollectionViewCell

static int padding = 5;
static int collumnNumber = 2;

- (CGFloat)cellWidth {
    if (!_cellWidth) {
        _cellWidth = (SCREEN_WIDTH - (collumnNumber - 1) * padding) / collumnNumber;
        _cellHeight = _cellWidth ;
    }
    return _cellWidth;
}

- (UIImageView *)collectionImageView {
    if (!_collectionImageView) {
        _collectionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, 40, self.cellWidth-padding, _cellHeight)];
        _collectionImageView.backgroundColor = [UIColor whiteColor];
        _collectionImageView.contentMode = UIViewContentModeScaleAspectFill;
        _collectionImageView.clipsToBounds = YES;
        [self addSubview:_collectionImageView];
    }
    return _collectionImageView;
}

- (UIButton *)userHeaderButton {
    if (!_userHeaderButton) {
        _userHeaderButton = [[UIButton alloc] initWithFrame:CGRectMake(padding, padding, 30, 30)];
        _userHeaderButton.userInteractionEnabled = NO;
        _userHeaderButton.backgroundColor = [UIColor orangeColor];
        _userHeaderButton.layer.cornerRadius = 14.5;
        _userHeaderButton.layer.masksToBounds = YES;
        [self addSubview:_userHeaderButton];
    }
    return _userHeaderButton;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userHeaderButton.frame) + 10, padding, 80, 30)];
        _userNameLabel.textColor = [UIColor colorWithHex:0x838383];
        [self addSubview:_userNameLabel];
    }
    return _userNameLabel;
}

- (void)setViewModel:(ATOMCollectionViewModel *)viewModel {
    _viewModel = viewModel;
    self.userNameLabel.text = viewModel.userName;
    [self.userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    [self.collectionImageView setImageWithURL:[NSURL URLWithString:viewModel.imageURL]];
}

























@end
