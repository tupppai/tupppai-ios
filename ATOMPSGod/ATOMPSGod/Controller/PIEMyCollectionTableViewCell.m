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
    _cornerLabel.hidden = YES;
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    _pageImageView.clipsToBounds = YES;
    _cornerLabel.textColor = [UIColor colorWithHex:0xFEAA2B andAlpha:1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)injectSauce:(DDPageVM*)vm {
    if (vm.type == PIEPageTypeAsk) {
        _cornerLabel.hidden = NO;
        _likeView.hidden = YES;
        _originView.image = [UIImage imageNamed:@"pie_origin"];
    }
    else if (vm.type == PIEPageTypeReply) {
        _likeView.hidden = NO;
//        _likeButton.highlighted = vm.liked;
//        _likeButton.numberString = vm.likeCount;
        _cornerLabel.hidden = YES;
        _originView.image = [UIImage imageNamed:@"pie_reply"];
    }
    
    [_avatarView setImageWithURL:[NSURL URLWithString:vm.avatarURL]placeholderImage:[UIImage imageNamed:@"cellBG"]];
    [_pageImageView setImageWithURL:[NSURL URLWithString:vm.imageURL]placeholderImage:[UIImage imageNamed:@"cellBG"]];
    _nameLabel.text = vm.username;
    _contentLabel.text = vm.content;
    _cornerLabel.text = [NSString stringWithFormat:@"已有%@个帮P,马上参与PK",vm.totalPSNumber];
}

@end
