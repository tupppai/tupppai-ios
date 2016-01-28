//
//  PIEChannelTutorialCommentsCountTableViewCell.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/27/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialCommentsCountTableViewCell.h"

@implementation PIEChannelTutorialCommentsCountTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)injectCommentCount:(NSUInteger)count
{
    NSString *prompt =
    [NSString stringWithFormat:@"评论（%ld）",(long)count];
    
    self.commentCountLabel.text = prompt;
}


@end
