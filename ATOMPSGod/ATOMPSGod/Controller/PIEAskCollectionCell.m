//
//  PIEAskCollectionCell.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/16/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEAskCollectionCell.h"
#import "PIEImageEntity.h"
@implementation PIEAskCollectionCell

- (void)awakeFromNib {
    self.layer.cornerRadius = 6;
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    _leftImageView.clipsToBounds = YES;
    _rightImageView.clipsToBounds = YES;
}

//put a needle injecting into cell's ass.
- (void)injectSource:(DDPageVM*)vm {
    [_avatarView setImageWithURL:[NSURL URLWithString:vm.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    _nameLabel.text = vm.username;
    _timeLabel.text = vm.publishTime;
   
    if (vm.askImageModelArray.count == 2) {
        PIEImageEntity* entity1 = [vm.askImageModelArray objectAtIndex:0];
        PIEImageEntity* entity2 = [vm.askImageModelArray objectAtIndex:1];
        [_leftImageView setImageWithURL:[NSURL URLWithString:entity1.url]];
        [_rightImageView setImageWithURL:[NSURL URLWithString:entity2.url]];
        [_rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.frame.size.width/2));
        }];
    } else {
        PIEImageEntity* entity1 = [vm.askImageModelArray objectAtIndex:0];
        [_leftImageView setImageWithURL:[NSURL URLWithString:entity1.url]];
        [_rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(0));
        }];
    }
//    _contentLabel.text = @"";
}
@end
