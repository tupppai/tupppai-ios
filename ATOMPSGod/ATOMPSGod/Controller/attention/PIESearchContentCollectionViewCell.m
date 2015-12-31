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

    _avatarButton.userInteractionEnabled = NO;
    _avatarButton.imageView.userInteractionEnabled = YES;

    _nameLabel.font = [UIFont lightTupaiFontOfSize:11];
    _nameLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.8];
}

- (void)injectSauce:(PIEPageVM*)vm {
    
    NSString *avatar_url =
    [vm.avatarURL trimToImageWidth:_avatarButton.frame.size.width * SCREEN_SCALE];
    
    [DDService sd_downloadImage:avatar_url
                      withBlock:^(UIImage *image) {
                          [_avatarButton setImage:image
                                         forState:UIControlStateNormal];
                          
                      }];
    
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
