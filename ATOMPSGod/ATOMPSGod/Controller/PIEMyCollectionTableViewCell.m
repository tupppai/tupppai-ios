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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _likeView.hidden = YES;
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    _pageImageView.clipsToBounds = YES;
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)injectSauce:(DDPageVM*)vm {
    if (vm.type == PIEPageTypeAsk) {
        _likeView.hidden = YES;
        _likeCountLabel.hidden = YES;
        _originView.image = [UIImage imageNamed:@"pie_origin"];
    }
    else if (vm.type == PIEPageTypeReply) {
        _likeView.hidden = NO;
        _likeCountLabel.hidden = NO;
        _likeCountLabel.text = vm.likeCount;
        _originView.image = [UIImage imageNamed:@"pie_reply"];
    }
    
    [_avatarView setImageWithURL:[NSURL URLWithString:vm.avatarURL]placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    [_pageImageView setImageWithURL:[NSURL URLWithString:vm.imageURL]placeholderImage:[UIImage imageNamed:@"cellBG"]];
    _nameLabel.text = vm.username;
    _contentLabel.text = vm.content;
}

@end
