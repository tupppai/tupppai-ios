//
//  ATOMInviteMessageTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMInviteMessageTableViewCell.h"
#import "ATOMInviteMessageViewModel.h"
#import "DDAskPageVM.h"

@implementation ATOMInviteMessageTableViewCell

static int padding20 = 20;
static int padding10 = 10;


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
    _userHeaderButton.layer.cornerRadius = 22.5;
    _userHeaderButton.layer.masksToBounds = YES;
    [self addSubview:_userHeaderButton];
    
    _userSexImageView = [UIImageView new];
    [self addSubview:_userSexImageView];
    
    _userNameLabel = [UILabel new];
    _userNameLabel.font = [UIFont systemFontOfSize:16.f];
    _userNameLabel.textColor = [UIColor colorWithHex:0x00adef];
    _userNameLabel.font = [UIFont systemFontOfSize:20.f];
    [self addSubview:_userNameLabel];
    
    _inviteContentLabel = [UILabel new];
    _inviteContentLabel.textColor = [UIColor colorWithHex:0x828282];
    _inviteContentLabel.font = [UIFont systemFontOfSize:16.f];
    [self addSubview:_inviteContentLabel];
    
    _inviteTimeLabel = [UILabel new];
    _inviteTimeLabel.font = [UIFont systemFontOfSize:10.f];
    _inviteTimeLabel.textColor = [UIColor colorWithHex:0x797979];
    [self addSubview:_inviteTimeLabel];
    
    _workImageView = [UIImageView new];
    _workImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_workImageView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _userHeaderButton.frame = CGRectMake(padding10, padding20, 45, 45);
    _userSexImageView.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - SEXRADIUS, CGRectGetMaxY(_userHeaderButton.frame) - SEXRADIUS, SEXRADIUS, SEXRADIUS);
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, padding20, SCREEN_WIDTH - padding10 * 4 - 75 - 45, 20);
    _inviteContentLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, CGRectGetMaxY(_userNameLabel.frame), SCREEN_WIDTH - padding10 * 4 - 75 - 45, 30);
    _inviteTimeLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, CGRectGetMaxY(_inviteContentLabel.frame), 150, 15);
    _workImageView.frame = CGRectMake(SCREEN_WIDTH - padding10 - 75, padding10, 75, 75);
}

- (void)setViewModel:(ATOMInviteMessageViewModel *)viewModel {
    _viewModel = viewModel;
    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    _userNameLabel.text = viewModel.userName;
    _userSexImageView.image = [UIImage imageNamed:viewModel.userSex];
    _inviteContentLabel.text = @"邀请你帮忙P图";
    _inviteTimeLabel.text = viewModel.publishTime;
    [_workImageView setImageWithURL:[NSURL URLWithString:viewModel.homepageViewModel.userImageURL]];
}





























@end
