//
//  ATOMProceedingTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMProceedingTableViewCell.h"
#import "ATOMProceedingViewModel.h"

@implementation ATOMProceedingTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _userHeaderButton = [UIButton new];
    _userHeaderButton.userInteractionEnabled = NO;
    _userHeaderButton.layer.cornerRadius = kfcAvatarWidth / 2;
    _userHeaderButton.layer.masksToBounds = YES;
    [self addSubview:_userHeaderButton];
    
    _userNameLabel = [UILabel new];
    _userNameLabel.font = [UIFont systemFontOfSize:kFont14];
    [self addSubview:_userNameLabel];
    
    _uploadButton = [UIButton new];
    _uploadButton.userInteractionEnabled = NO;
    [_uploadButton setBackgroundImage:[UIImage imageNamed:@"icon_upload"] forState:UIControlStateNormal];
    [self addSubview:_uploadButton];
    
    _userUploadImageView = [UIImageView new];
    [self addSubview:_userUploadImageView];
    
    _timeImageView = [UIImageView new];
    _timeImageView.image = [UIImage imageNamed:@"icon_clock"];
    [self addSubview:_timeImageView];
    
    _userPublishTimeLabel = [UILabel new];
    _userPublishTimeLabel.font = [UIFont systemFontOfSize:kFont14];
    [self addSubview:_userPublishTimeLabel];
    
    _deleteButton = [UIButton new];
    _deleteButton.userInteractionEnabled = NO;
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
    [self addSubview:_deleteButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _userHeaderButton.frame = CGRectMake(kPadding15, (60 - kfcAvatarWidth) / 2, kfcAvatarWidth, kfcAvatarWidth);
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + kPadding15, (60 - kFont14) / 2, kUserNameLabelWidth, kFont14+2);
    _uploadButton.frame = CGRectMake(SCREEN_WIDTH - kPadding15 - 27, 16.5, 27, 27);
    CGSize imageSize = CGSizeZero;
    if (_viewModel) {
        imageSize = CGSizeMake(_viewModel.width, _viewModel.height);
    }
    _userUploadImageView.frame = CGRectMake((SCREEN_WIDTH - imageSize.width) / 2, 60, imageSize.width, imageSize.height);

    _timeImageView.frame = CGRectMake(kPadding15, (50 - 14) / 2 + CGRectGetMaxY(_userUploadImageView.frame), 14, 14);
    _userPublishTimeLabel.frame = CGRectMake(CGRectGetMaxX(_timeImageView.frame) + kPadding15, (50 - kFont14) / 2 + CGRectGetMaxY(_userUploadImageView.frame), kPublishTimeLabelWidth, kFont14);
    _userPublishTimeLabel.minimumScaleFactor = 0.6;
    _deleteButton.frame = CGRectMake(SCREEN_WIDTH - kPadding15 - 27, (50 - 27) / 2 + CGRectGetMaxY(_userUploadImageView.frame), 27, 27);
}

+ (CGFloat)calculateCellHeight:(ATOMProceedingViewModel *)viewModel {
    return 60 + viewModel.height + 50;
}

- (void)setViewModel:(ATOMProceedingViewModel *)viewModel {
    _viewModel = viewModel;
    _userNameLabel.text = viewModel.userName;
    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    [_userUploadImageView setImageWithURL:[NSURL URLWithString:viewModel.imageURL]];
    _userPublishTimeLabel.text = viewModel.publishTime;
    [self setNeedsLayout];
}



































@end
