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
    _pageImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)injectSauce:(PIEPageVM* )vm {
    _usernameLabel.text = vm.username;
    _timeLabel.text = vm.publishTime;
    _contentLabel.text = [NSString stringWithFormat:@"你评论了%@: %@",vm.username,vm.content];
    [_pageImageView sd_setImageWithURL:[NSURL URLWithString:vm.imageURL] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
    
}
@end
