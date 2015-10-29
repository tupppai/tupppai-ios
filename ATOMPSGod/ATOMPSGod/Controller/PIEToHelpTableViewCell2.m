//
//  PIEToHelpTableViewCell2.m
//  TUPAI
//
//  Created by chenpeiwei on 10/9/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEToHelpTableViewCell2.h"

@implementation PIEToHelpTableViewCell2

- (void)awakeFromNib {
    // Initialization code
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    _theImageView.clipsToBounds = YES;
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//put a needle injecting into cell's ass.
- (void)injectSource:(DDPageVM*)vm {
    [_avatarView setImageWithURL:[NSURL URLWithString:vm.avatarURL] placeholderImage:[UIImage imageNamed:@"cellBG"]];
    [_theImageView setImageWithURL:[NSURL URLWithString:vm.imageURL] placeholderImage:[UIImage imageNamed:@"cellBG"]];
    _nameLabel.text = vm.username;
    _timeLabel.text = vm.publishTime;
    _contentLabel.text = vm.content;
    _paticipantLabel.text = [NSString stringWithFormat:@"已有%@人帮p,马上参与pk!",vm.totalPSNumber];
}

@end
