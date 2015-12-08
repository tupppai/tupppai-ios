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
    
    _usernameLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:1.0];
    _contentLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.9];
    _timeLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.5];
    _replyLabel.textColor = [UIColor colorWithHex:0xff6d3f andAlpha:1.0];
    _typeLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.5];

    _usernameLabel.font = [UIFont lightTupaiFontOfSize:13];
    _contentLabel.font = [UIFont lightTupaiFontOfSize:14];
    _replyLabel.font = [UIFont lightTupaiFontOfSize:12];
    _timeLabel.font = [UIFont lightTupaiFontOfSize:10];
    _typeLabel.font = [UIFont lightTupaiFontOfSize:13];
    
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    _pageImageView.clipsToBounds = YES;
}

- (void)injectSauce:(PIENotificationVM*)vm {
    [_avatarView setImageWithURL:[NSURL URLWithString:vm.avatarUrl]placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _usernameLabel.text = vm.username;
    _timeLabel.text = vm.time;
    _contentLabel.text = vm.content;
    [_pageImageView setImageWithURL:[NSURL URLWithString:vm.imageUrl]placeholderImage:[UIImage imageNamed:@"cellHolder"]];
}

@end
