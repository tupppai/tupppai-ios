//
//  PIENotificationCommentTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/14/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENotificationCommentTableViewCell.h"

@implementation PIENotificationCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, 45, 0, 10);

    _contentLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.9];
    _replyLabel.textColor = [UIColor colorWithHex:0xFF6D3F andAlpha:1];
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    _pageImageView.clipsToBounds = YES;
}

- (void)injectSauce:(PIENotificationVM*)vm {
    [_avatarView setImageWithURL:[NSURL URLWithString:vm.avatarUrl]placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _usernameLabel.text = vm.username;
    _timeLabel.text = vm.time;
    _contentLabel.text = vm.content;
    [_pageImageView setImageWithURL:[NSURL URLWithString:vm.imageUrl]placeholderImage:[UIImage imageNamed:@"cellBG"]];
}

@end
