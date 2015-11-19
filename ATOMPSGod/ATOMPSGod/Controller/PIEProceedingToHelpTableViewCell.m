//
//  PIEToHelpTableViewCell.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/18/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEProceedingToHelpTableViewCell.h"

@implementation PIEProceedingToHelpTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    _theImageView.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, 125, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

//put a needle injecting into cell's ass.
- (void)injectSource:(PIEPageVM*)vm {
    [_avatarView setImageWithURL:[NSURL URLWithString:vm.avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    [_theImageView setImageWithURL:[NSURL URLWithString:vm.imageURL]placeholderImage:[UIImage imageNamed:@"cellBG"]];
    _nameLabel.text = vm.username;
    _timeLabel.text = vm.publishTime;
    _contentLabel.text = vm.content;
}

@end
