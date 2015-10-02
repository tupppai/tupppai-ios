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
    _likeView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesLike = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(like)];
    [_likeView addGestureRecognizer:tapGesLike];
}
- (void)injectSauce:(DDPageVM *)viewModel {
    [_imageView setImageWithURL:[NSURL URLWithString:viewModel.imageURL] placeholderImage:[UIImage imageNamed:@"cellBG"]];
    [_avatarView setImageWithURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"cellBG"]];
    _usernameLabel.text = viewModel.username;
    _ID = viewModel.ID;
    _type = viewModel.type;
    _likeView.highlighted = viewModel.liked;
}
- (void)like {
    _likeView.highlighted = !_likeView.highlighted;
    [DDService toggleLike:_likeView.highlighted ID:_ID type:_type withBlock:^(BOOL success) {
        if (!success) {
            _likeView.highlighted = !_likeView.highlighted;
        }
    }];
}
@end
