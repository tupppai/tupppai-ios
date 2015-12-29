//
//  PIESearchUserTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 11/24/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIESearchUserSimpleCollectionCell.h"

@implementation PIESearchUserSimpleCollectionCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
//    _avatarButton.layer.cornerRadius = _avatarButton.frame.size.width/2;
//    _avatarButton.clipsToBounds = YES;
    _avatarButton.backgroundColor = [UIColor lightGrayColor];
    _countLabel.textColor = [UIColor colorWithHex:0x4a4a4a andAlpha:0.8];
    _followButton.imageView.contentMode = UIViewContentModeScaleAspectFill;

    _nameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_nameButton.titleLabel setFont:[UIFont lightTupaiFontOfSize:14]];
    _countLabel.font = [UIFont lightTupaiFontOfSize:11];
    [_nameButton setTitleColor:[UIColor colorWithHex:0x000000 andAlpha:0.9] forState:UIControlStateNormal];
    _countLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.8];
    _avatarButton.userInteractionEnabled = NO;
    _nameButton.userInteractionEnabled = NO;
    _followButton.userInteractionEnabled = NO;
    
}


- (void)injectSauce:(PIEUserViewModel*)vm {
    _vm = vm;
    [_avatarButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:vm.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    // 目前接口还没有提供数据
//    _avatarButton.isV
    _avatarButton.isV = vm.model.isV;
    
    
    [_nameButton setTitle:vm.username forState:UIControlStateNormal];
    _countLabel.text = [NSString stringWithFormat:@"%@ 作品   %@ 粉丝   %@ 关注",vm.replyCount,vm.fansCount,vm.followCount];
    _followButton.selected = vm.model.isMyFollow;
}

@end
