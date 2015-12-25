//
//  PIEReplyCollectionViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/2/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEReplyCollectionCell.h"

@implementation PIEReplyCollectionCell

- (void)awakeFromNib {
    // Initialization code
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8;
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _likeButton.userInteractionEnabled = NO;
    [_likeButton setTitleColor:[UIColor colorWithHex:0x999999]
                      forState:UIControlStateNormal];
    [_likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [_likeButton setContentEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [_likeButton setImage:[UIImage imageNamed:@"sharpCornerLike"]
                 forState:UIControlStateNormal];

    
}
-(void)setSelected:(BOOL)selected {
}

- (void)injectSauce:(PIEPageVM *)viewModel {
    _viewModel = viewModel;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:viewModel.imageURL] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _usernameLabel.text = viewModel.username;
    _ID = viewModel.ID;
    _type = viewModel.type;
//    _likeButton.highlighted = viewModel.liked;
    _likeButton.imageView.image = [UIImage imageNamed:@"pie_myCollection_like"];
       [_likeButton setTitle:viewModel.likeCount
                 forState:UIControlStateNormal];
    
    
}

@end
