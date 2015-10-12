//
//  PIEMyCollectionTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/12/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEMyCollectionTableViewCell.h"

@implementation PIEMyCollectionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)injectSauce:(DDPageVM*)vm {
    [_avatarView setImageWithURL:[NSURL URLWithString:vm.avatarURL]];
    [_pageImageView setImageWithURL:[NSURL URLWithString:vm.imageURL]];
    _nameLabel.text = vm.username;
    _contentLabel.text = vm.content;
    _cornerLabel.text = @"已有%zd个帮P,马上参与PK";
}

@end
