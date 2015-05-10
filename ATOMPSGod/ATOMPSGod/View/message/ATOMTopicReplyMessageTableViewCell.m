//
//  ATOMTopicReplyMessageTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMTopicReplyMessageTableViewCell.h"
#import "ATOMReplyMessageViewModel.h"

@implementation ATOMTopicReplyMessageTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
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
    _userHeaderButton.layer.cornerRadius = kUserHeaderButtonWidth2 / 2;
    _userHeaderButton.layer.masksToBounds = YES;
    [self addSubview:_userHeaderButton];
    
    _userSexImageView = [UIImageView new];
    [self addSubview:_userSexImageView];
    
    _userNameLabel = [UILabel new];
    _userNameLabel.textColor = [UIColor colorWithHex:0x000000];
    _userNameLabel.font = [UIFont systemFontOfSize:kFont15];
    [self addSubview:_userNameLabel];
    
    _topicReplyContentLabel = [UILabel new];
    _topicReplyContentLabel.textColor = [UIColor colorWithHex:0x585858];
    _topicReplyContentLabel.font = [UIFont systemFontOfSize:kFont14];
    [self addSubview:_topicReplyContentLabel];
    
    _topicReplyTimeLabel = [UILabel new];
    _topicReplyTimeLabel.font = [UIFont systemFontOfSize:kFont10];
    _topicReplyTimeLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.4];
    [self addSubview:_topicReplyTimeLabel];
    
    _workImageView = [UIImageView new];
    _workImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_workImageView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _userHeaderButton.frame = CGRectMake(kPadding15, kPadding20, kUserHeaderButtonWidth2, kUserHeaderButtonWidth2);
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + kPadding20, kPadding20, kUserNameLabelWidth, kFont15);
    _topicReplyContentLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + kPadding20, CGRectGetMaxY(_userHeaderButton.frame) - kFont14, kUserNameLabelWidth, kFont14);
    _topicReplyTimeLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + kPadding20, 100 - kPadding15 - kFont10, kUserNameLabelWidth, kFont10);
    _workImageView.frame = CGRectMake(SCREEN_WIDTH - kPadding15 - 65, kPadding20, 65, 65);
}

- (void)setViewModel:(ATOMReplyMessageViewModel *)viewModel {
    _viewModel = viewModel;
    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    _userNameLabel.text = viewModel.userName;
    _topicReplyContentLabel.text = viewModel.theme;
    _topicReplyTimeLabel.text = viewModel.publishTime;
    _userSexImageView.image = [UIImage imageNamed:viewModel.userSex];
    [_workImageView setImageWithURL:[NSURL URLWithString:viewModel.imageURL]];
}

















@end
