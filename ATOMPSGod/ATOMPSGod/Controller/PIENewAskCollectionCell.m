//
//  PIEAskCollectionCell.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/16/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENewAskCollectionCell.h"
#import "PIEImageEntity.h"
@implementation PIENewAskCollectionCell

- (void)awakeFromNib {
    self.layer.cornerRadius = 6;
    self.backgroundColor = [UIColor whiteColor];
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    _leftImageView.clipsToBounds = YES;
    _rightImageView.clipsToBounds = YES;
    _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    _contentLabel.text = @"";
    [_nameLabel setFont:[UIFont lightTupaiFontOfSize:12]];
    [_contentLabel setFont:[UIFont lightTupaiFontOfSize:12]];
    [_timeLabel setFont:[UIFont lightTupaiFontOfSize:9]];

    [_nameLabel setTextColor:[UIColor colorWithHex:0x4a4a4a andAlpha:1.0]];
    [_timeLabel setTextColor:[UIColor colorWithHex:0x4a4a4a andAlpha:0.3]];
    [_contentLabel setTextColor:[UIColor colorWithHex:0x000000 andAlpha:0.9]];

//    _leftImageView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.4];
//    _rightImageView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.4];
}

//put a needle injecting into cell's ass.
- (void)injectSource:(PIEPageVM*)vm {
    [_avatarView setImageWithURL:[NSURL URLWithString:vm.avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _nameLabel.text = vm.username;
    _timeLabel.text = vm.publishTime;
   
    if (vm.thumbEntityArray.count == 2) {
        PIEImageEntity* entity1 = [vm.thumbEntityArray objectAtIndex:0];
        PIEImageEntity* entity2 = [vm.thumbEntityArray objectAtIndex:1];
        [_leftImageView setImageWithURL:[NSURL URLWithString:entity1.url]placeholderImage:[UIImage imageNamed:@"cellBG"]];
        [_rightImageView setImageWithURL:[NSURL URLWithString:entity2.url]placeholderImage:[UIImage imageNamed:@"cellBG"]];
        [_rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.frame.size.width/2));
        }];

    } else if (vm.thumbEntityArray.count == 1) {
        PIEImageEntity* entity1 = [vm.thumbEntityArray objectAtIndex:0];
        [_leftImageView setImageWithURL:[NSURL URLWithString:entity1.url]placeholderImage:[UIImage imageNamed:@"cellBG"]];
        [_rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(0));
        }];
    }
    _contentLabel.text = vm.content;
    [self updateConstraintsIfNeeded];
}
@end
