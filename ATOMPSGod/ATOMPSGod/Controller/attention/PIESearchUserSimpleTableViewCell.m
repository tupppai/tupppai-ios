//
//  PIESearchUserSimpleTableViewCell.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/17/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIESearchUserSimpleTableViewCell.h"

@implementation PIESearchUserSimpleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.backgroundColor = [UIColor whiteColor];
    
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
    _avatarButton.imageView.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)injectSauce:(PIEUserViewModel*)vm {
    _vm = vm;
    NSString *avatar_url = [vm.avatar trimToImageWidth:_avatarButton.frame.size.width*SCREEN_SCALE];
    
    [DDService sd_downloadImage:avatar_url
                      withBlock:^(UIImage *image) {
                          [_avatarButton setImage:image
                                         forState:UIControlStateNormal];
                      }];
    
    _avatarButton.isV = vm.model.isV;
    
    [_nameButton setTitle:vm.username forState:UIControlStateNormal];
    _countLabel.text       =
    [NSString stringWithFormat:@"%@ 作品   %@ 粉丝   %@ 关注",vm.replyCount,vm.fansCount,vm.followCount];
    
    /*
        TODO: 深入判断是单方面关注，还是互相关注
     */
    _followButton.selected = vm.model.isMyFollow;
}


@end
