//
//  PIESearchContentCollectionViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 11/3/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIESearchContentCollectionViewCell.h"

@implementation PIESearchContentCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 6;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    _avatarButton.layer.cornerRadius = _avatarButton.frame.size.width/2;
    _avatarButton.clipsToBounds = YES;
    _avatarButton.backgroundColor = [UIColor lightGrayColor];
    _avatarButton.userInteractionEnabled = NO;
}

- (void)injectSauce:(DDPageVM*)vm {
    [_avatarButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:vm.avatarURL] placeholderImage:[UIImage imageNamed:@"cellBG"]];
    _nameLabel.text = vm.username;
    _contentLabel.text = vm.content;
    [_imageView setImageWithURL:[NSURL URLWithString:vm.imageURL] placeholderImage:[UIImage imageNamed:@"cellBG"]];
    if (vm.type == PIEPageTypeAsk) {
        _typeImageView.image = [UIImage imageNamed:@"pie_search_ask"];
    }else if (vm.type == PIEPageTypeReply) {
        _typeImageView.image = [UIImage imageNamed:@"pie_search_reply"];
    }
}

@end
