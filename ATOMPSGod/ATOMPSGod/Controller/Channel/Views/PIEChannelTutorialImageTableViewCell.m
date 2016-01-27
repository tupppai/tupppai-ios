//
//  PIEChannelTutorialImageTableViewCell.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/25/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialImageTableViewCell.h"
#import "PIEChannelTutorialImageModel.h"

@implementation PIEChannelTutorialImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)injectImageModel:(PIEChannelTutorialImageModel *)tutorialImageModel
{
    [self.tutorialImageView
     sd_setImageWithURL:[NSURL URLWithString:tutorialImageModel.imageURL]];
    
    /*
        layout the cell or something?
     */
}


@end
