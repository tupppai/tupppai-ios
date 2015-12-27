//
//  PIEAskCollectionCell.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/16/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENewAskCollectionCell.h"
#import "PIEModelImage.h"
@implementation PIENewAskCollectionCell

- (void)awakeFromNib {
    self.layer.cornerRadius = 6;
    self.backgroundColor = [UIColor whiteColor];
//    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
//    _avatarView.clipsToBounds = YES;
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
    _imageView_multiAskSign.hidden = YES;

}

//put a needle injecting into cell's ass.
- (void)injectSource:(PIEPageVM*)vm {
    
    _vm = vm;
    NSString *urlString_avatar = [vm.avatarURL trimToImageWidth:_avatarView.frame.size.width*SCREEN_SCALE];
    NSString *urlString_imageView = [vm.imageURL trimToImageWidth:SCREEN_WIDTH_RESOLUTION];
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:urlString_imageView] placeholderImage:[UIImage imageNamed:@"cell_holder_portrait"]];
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:urlString_avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
//    _avatarView.isV = vm.isV;
    _avatarView.isV = YES;
    _nameLabel.text = vm.username;
    _timeLabel.text = vm.publishTime;
    _contentLabel.text = vm.content;

    if (vm.models_image.count >= 2) {
        _imageView_multiAskSign.hidden = NO;
    } else {
        _imageView_multiAskSign.hidden = YES;
    }
}
@end
