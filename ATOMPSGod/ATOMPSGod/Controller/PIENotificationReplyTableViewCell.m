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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _usernameLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:1.0];
    _timeLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.5];
    _replyLabel.textColor = [UIColor colorWithHex:0xff6d3f andAlpha:1.0];
    _usernameLabel.font = [UIFont lightTupaiFontOfSize:13];
    _replyLabel.font = [UIFont lightTupaiFontOfSize:12];
    _timeLabel.font = [UIFont lightTupaiFontOfSize:10];
    _typeLabel.font = [UIFont lightTupaiFontOfSize:13];

    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    _pageImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)injectSauce:(PIENotificationVM*)vm {
    NSString* avatarUrl = [vm.avatarUrl trimToImageWidth:_avatarView.frame.size.width*SCREEN_SCALE];
    NSString* pageImageUrl = [vm.imageUrl trimToImageWidth:_pageImageView.frame.size.width*SCREEN_SCALE];

    [_pageImageView sd_setImageWithURL:[NSURL URLWithString:pageImageUrl]placeholderImage:[UIImage imageNamed:@"cellHolder"]];
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:avatarUrl]placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _usernameLabel.text = vm.username;
    _timeLabel.text = vm.time;
}
@end
