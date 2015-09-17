//
//  PIEAskCollectionCell.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/16/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEAskCollectionCell.h"

@implementation PIEAskCollectionCell

- (void)awakeFromNib {
    self.layer.cornerRadius = 6;
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    _theImageView.clipsToBounds = YES;
}

//put a needle injecting into cell's ass.
- (void)injectSource:(DDPageVM*)vm {
    [_avatarView setImageWithURL:[NSURL URLWithString:vm.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    _nameLabel.text = vm.username;
    _timeLabel.text = vm.publishTime;
    [_theImageView setImageWithURL:[NSURL URLWithString:vm.imageURL]];
//    _contentLabel.text = @"";
}
@end
