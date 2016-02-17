//
//  PIEChannelTutorialTeacherDescTableViewCell.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/25/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialTeacherDescTableViewCell.h"
#import "PIEAvatarView.h"
#import "PIEChannelTutorialModel.h"


@interface PIEChannelTutorialTeacherDescTableViewCell ()

@property (nonatomic, strong) UITapGestureRecognizer *tap;


@end

@implementation PIEChannelTutorialTeacherDescTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self.avatarView addGestureRecognizer:tap];
    self.avatarView.avatarImageView.userInteractionEnabled = YES;
    self.avatarView.userInteractionEnabled                 = YES;
    self.tap = tap;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)injectModel:(PIEChannelTutorialModel *)tutorialModel
{
//    [self.avatarView.avatarImageView
//     sd_setImageWithURL:[NSURL URLWithString:tutorialModel.avatarUrl]];
    
    self.avatarView.url = tutorialModel.avatarUrl;
    
    self.userNameLabel.text    = tutorialModel.userName;

    self.createdTimeLabel.text = tutorialModel.publishTime;
    
    self.avatarView.isV = tutorialModel.isV;
    
    if (tutorialModel.isMyFan) {
        [self.followButton setImage:[UIImage imageNamed:@"pie_mutualfollow"]
                           forState:UIControlStateSelected];
    }else{
        [self.followButton setImage:[UIImage imageNamed:@"new_reply_followed"]
                           forState:UIControlStateSelected];
    }
    
    RAC(self.followButton,selected) =
    [RACObserve(tutorialModel, isMyFollow) takeUntil:self.rac_prepareForReuseSignal];
    
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
}

- (RACSignal *)tapOnAvatar
{
    if (_tapOnAvatar == nil) {
        _tapOnAvatar = [[self.tap rac_gestureSignal]
                        takeUntil:self.rac_prepareForReuseSignal];
    }
    return _tapOnAvatar;
}

- (RACSignal *)tapOnFollowButton
{
    if (_tapOnFollowButton == nil) {
        _tapOnFollowButton =
        [[self.followButton
          rac_signalForControlEvents:UIControlEventTouchUpInside]
         takeUntil:self.rac_prepareForReuseSignal];
    }
    
    return  _tapOnFollowButton;
}

@end
