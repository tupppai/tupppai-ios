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
    UITapGestureRecognizer* tapGesLike = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(like)];
    [_likeButton addGestureRecognizer:tapGesLike];
    _imageView.clipsToBounds = YES;
}
- (void)injectSauce:(DDPageVM *)viewModel {
    _viewModel = viewModel;
    [_imageView setImageWithURL:[NSURL URLWithString:viewModel.imageURL] placeholderImage:[UIImage imageNamed:@"cellBG"]];
    [_avatarView setImageWithURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"cellBG"]];
    _usernameLabel.text = viewModel.username;
    _ID = viewModel.ID;
    _type = viewModel.type;
    _likeButton.highlighted = viewModel.liked;
    _likeButton.numberString = viewModel.likeCount;
}
- (void)like {
    _likeButton.selected = !_likeButton.selected;
    [DDService toggleLike:_likeButton.selected ID:_ID type:_type withBlock:^(BOOL success) {
        if (!success) {
            _likeButton.selected = !_likeButton.selected;
        } else {
            
            if (_likeButton.selected) {
                _viewModel.likeCount = [NSString stringWithFormat:@"%zd",_viewModel.likeCount.integerValue + 1];
            } else {
                _viewModel.likeCount = [NSString stringWithFormat:@"%zd",_viewModel.likeCount.integerValue - 1];
            }
            _viewModel.liked = _likeButton.selected;
        }
    }];
}
@end
