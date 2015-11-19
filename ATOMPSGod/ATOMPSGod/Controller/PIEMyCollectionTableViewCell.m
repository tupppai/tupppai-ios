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
    _nameLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.6];
    _contentLabel.textColor =[UIColor colorWithHex:0x000000 andAlpha:0.8];
    [self addLine];
}

- (void)addLine {
    UIView* line = [UIView new];
    line.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.2];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)injectSauce:(PIEPageVM*)vm {
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
