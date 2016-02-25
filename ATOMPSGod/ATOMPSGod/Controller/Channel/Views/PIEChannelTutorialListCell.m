//
//  PIEChannelTutorialListCell.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/24/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialListCell.h"
#import "PIEAvatarView.h"
#import "PIEChannelTutorialModel.h"


@implementation PIEChannelTutorialListCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.avatarView.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarView.avatarImageView.layer.borderWidth = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)injectModel:(PIEChannelTutorialModel *)tutorialModel
{
    // 使用教程图片的第一张图片作为List的封面
    
//    NSString *firstTutorialImageUrlStr = [tutorialModel.tutorial_images firstObject].imageURL;
    
    NSString *firstTutorialImageUrlStr = tutorialModel.coverImageUrl;
    
    [self.tutorialImageView sd_setImageWithURL:[NSURL URLWithString:firstTutorialImageUrlStr]];
    
    [self.avatarView.avatarImageView sd_setImageWithURL:
     [NSURL URLWithString:tutorialModel.avatarUrl]];
    
    self.avatarView.isV       = tutorialModel.isV;

    self.userNameLabel.text   = tutorialModel.userName;

    self.tutorialTitle.text   = tutorialModel.title;

    self.loveCountLabel.text  = [@(tutorialModel.love_count) stringValue];

    self.clickCountLabel.text = [@(tutorialModel.click_count) stringValue];

    self.replyCountLabel.text = [@(tutorialModel.reply_count) stringValue];
    
}

@end
