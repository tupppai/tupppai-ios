//
//  PIENotificationSystemTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/14/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENotificationSystemTableViewCell.h"

@implementation PIENotificationSystemTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, 45, 0, 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)injectSauce:(PIENotificationVM*)vm {
    _timeLabel.text = vm.time;
    _contentLabel.text = vm.content;
    [_avatarView setImageWithURL:[NSURL URLWithString:vm.avatarUrl]];
}
@end
