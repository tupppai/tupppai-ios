//
//  PIEMyCommentedPageTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/17/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEMyCommentedPageTableViewCell.h"

@implementation PIEMyCommentedPageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)injectSauce:(DDPageVM* )vm {
    _usernameLabel.text = vm.username;
    _timeLabel.text = vm.publishTime;
    _contentLabel.text = vm.content;
    [_pageImageView setImageWithURL:[NSURL URLWithString:vm.imageURL] placeholderImage:[UIImage imageNamed:@"cellBG"]];
}
@end
