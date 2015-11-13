//
//  PIENotificationFollowTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/14/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENotificationFollowTableViewCell.h"

@implementation PIENotificationFollowTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, 45, 0, 10);
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)injectSauce:(PIENotificationVM*)vm {
    [_avatarView setImageWithURL:[NSURL URLWithString:vm.avatarUrl]placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _usernameLabel.text = vm.username;
    _timeLabel.text = vm.time;
}
@end
