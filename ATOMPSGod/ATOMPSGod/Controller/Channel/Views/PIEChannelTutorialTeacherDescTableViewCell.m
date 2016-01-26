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

@implementation PIEChannelTutorialTeacherDescTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)injectModel:(PIEChannelTutorialModel *)tutorialModel
{
    [self.avatarView.avatarImageView
     sd_setImageWithURL:[NSURL URLWithString:tutorialModel.avatarUrl]];
    
    self.userNameLabel.text    = tutorialModel.userName;

    self.createdTimeLabel.text = tutorialModel.publishTime;
    
    /* model漏了两个属性：isMyFan, isMyFollow */
    
}

@end
