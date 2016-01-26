//
//  PIEChannelTutorialPrefaceTableViewCell.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/24/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialPrefaceTableViewCell.h"
#import "PIEChannelTutorialModel.h"

@implementation PIEChannelTutorialPrefaceTableViewCell

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
    self.tutorialTitleLabel.text    = tutorialModel.title;
    self.tutorialSubtitleLabel.text = tutorialModel.subTitle;
    self.loveCountLabel.text        = [@(tutorialModel.love_count) stringValue];
    self.clickCountLabel.text       = [@(tutorialModel.click_count) stringValue];
    self.replyCountLabel.text       = [@(tutorialModel.reply_count) stringValue];
}

@end
