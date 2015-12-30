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
    self.backgroundColor                 = [UIColor whiteColor];
    self.layer.cornerRadius              = 6;
    _imageView.contentMode               = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds             = YES;
//    _avatarButton.layer.cornerRadius     = _avatarButton.frame.size.width/2;
//    _avatarButton.clipsToBounds          = YES;

    _avatarButton.userInteractionEnabled = YES;
    
    _nameLabel.font = [UIFont lightTupaiFontOfSize:11];
    _nameLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.8];
}

- (void)injectSauce:(PIEPageVM*)vm {
//    [_avatarButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:vm.avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
//    
    
//    [_avatarButton setImageForState:UIControlStateNormal
//                            withURL:[NSURL URLWithString:vm.avatarURL]
//                   placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    [DDService sd_downloadImage:vm.avatarURL
                      withBlock:^(UIImage *image) {
                          [_avatarButton setImage:image
                                         forState:UIControlStateNormal];
                          
                      }];
    
    
//    _avatarButton.isV = vm.isV;
//    _avatarButton.isV = YES;
    // testing:
//    _avatarButton.isV = (vm.askID % 2 == 0);
    _avatarButton.isV = vm.isV;
    
    _nameLabel.text = vm.username;
    _contentLabel.text = vm.content;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:vm.imageURL] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
    if (vm.type == PIEPageTypeAsk) {
        _typeImageView.image = [UIImage imageNamed:@"pie_search_ask"];
    }else if (vm.type == PIEPageTypeReply) {
        _typeImageView.image = [UIImage imageNamed:@"pie_search_reply"];
    }
}

@end
