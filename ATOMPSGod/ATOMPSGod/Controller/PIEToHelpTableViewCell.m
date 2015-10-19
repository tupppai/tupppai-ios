//
//  PIEToHelpTableViewCell.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/18/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEToHelpTableViewCell.h"

@implementation PIEToHelpTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    _theImageView.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//put a needle injecting into cell's ass.
- (void)injectSource:(DDPageVM*)vm {
    [_avatarView setImageWithURL:[NSURL URLWithString:vm.avatarURL]];
    [_theImageView setImageWithURL:[NSURL URLWithString:vm.imageURL]];
    _nameLabel.text = vm.username;
    _timeLabel.text = vm.publishTime;
    _paticipantLabel.text = [NSString stringWithFormat:@"已有%@人帮p,马上参与pk!",vm.totalPSNumber];
    _contentLabel.text = vm.content;
}

@end
