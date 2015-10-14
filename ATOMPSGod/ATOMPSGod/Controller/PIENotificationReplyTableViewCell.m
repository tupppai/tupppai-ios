//
//  PIENotificationReplyTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/14/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENotificationReplyTableViewCell.h"

@implementation PIENotificationReplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _replyLabel.textColor = [UIColor colorWithHex:0xFF6D3F andAlpha:0.9];
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
