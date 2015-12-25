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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    
    _usernameLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:1.0];
    _timeLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.5];
    _typeLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.5];
    
    _usernameLabel.font = [UIFont lightTupaiFontOfSize:13];
    _timeLabel.font = [UIFont lightTupaiFontOfSize:10];
    _typeLabel.font = [UIFont lightTupaiFontOfSize:13];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)injectSauce:(PIENotificationVM*)vm {
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:vm.avatarUrl]placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _usernameLabel.text = vm.username;
    _timeLabel.text = vm.time;
    [_pageImageView sd_setImageWithURL:[NSURL URLWithString:vm.imageUrl]placeholderImage:[UIImage imageNamed:@"cellHolder"]];
}
@end
