//
//  PIENotificationLikeTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/14/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENotificationLikeTableViewCell.h"

@implementation PIENotificationLikeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, 45, 0, 10);
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    _pageImageView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)injectSauce:(PIENotificationVM*)vm {
    [_avatarView setImageWithURL:[NSURL URLWithString:vm.avatarUrl]placeholderImage:[UIImage imageNamed:@"cellBG"]];
    _usernameLabel.text = vm.username;
    _timeLabel.text = vm.time;
    [_pageImageView setImageWithURL:[NSURL URLWithString:vm.imageUrl]placeholderImage:[UIImage imageNamed:@"cellBG"]];
}
@end
