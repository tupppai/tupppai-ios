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

    _pageImageView.clipsToBounds = YES;
    _nameLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.6];
    _contentLabel.textColor =[UIColor colorWithHex:0x000000 andAlpha:0.8];
    [_nameLabel setFont:[UIFont lightTupaiFontOfSize:12]];
    [_contentLabel setFont:[UIFont lightTupaiFontOfSize:14]];

    [self addLine];
}

- (void)addLine {
    UIView* line = [UIView new];
    line.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.1];
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
        _originView.image = [UIImage imageNamed:@"pie_origin_tag"];
    }
    else if (vm.type == PIEPageTypeReply) {
        
        // (需求) 我的个人主页，去掉“求P”，留下“作品”&“收藏”，收藏去掉“赞数”
        //        _likeView.hidden = NO;
//        _likeCountLabel.hidden = NO;
        _likeView.hidden       = YES;
        _likeCountLabel.hidden = YES;
        _likeCountLabel.text   = vm.likeCount;
        _originView.image      = [UIImage imageNamed:@"pie_origin_tag"];
    }
    
    [_avatarView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:vm.avatarURL]placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _avatarView.isV = vm.isV;
    [_pageImageView sd_setImageWithURL:[NSURL URLWithString:vm.imageURL]placeholderImage:[UIImage imageNamed:@"cellHolder"]];
    _nameLabel.text = vm.username;
    _contentLabel.text = vm.content;
}

@end
