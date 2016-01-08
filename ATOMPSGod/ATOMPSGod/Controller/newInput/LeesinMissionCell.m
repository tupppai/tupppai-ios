//
//  PIEMyMissionCell.m
//  PIEGrowingTextInput
//
//  Created by chenpeiwei on 1/6/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import "LeesinMissionCell.h"
#import "LeesinCheckmarkView.h"

@implementation LeesinMissionCell
-(void)awakeFromNib {
    [self pie_commonInit];
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self pie_commonInit];
    }
    return self;
}

- (void)pie_commonInit {
    _avatar.layer.cornerRadius = _avatar.frame.size.width/2;
    _avatar.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
}

-(void)setSelected:(BOOL)selected {
    if (_selected == selected) {
        return;
    }
    _selected = selected;
    _checkmark.selected = selected;
}

-(void)setViewModel:(PIEPageVM *)viewModel {
    _viewModel = viewModel;
    NSString *urlString_avatar = [viewModel.avatarURL trimToImageWidth:_avatar.frame.size.width*SCREEN_SCALE];
    NSString *urlString_imageView = [viewModel.imageURL trimToImageWidth:_imageView.frame.size.width*SCREEN_SCALE];
    viewModel.avatarURL = urlString_avatar;
    viewModel.imageURL = urlString_imageView;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:urlString_imageView]];
    
    [DDService sd_downloadImage:urlString_avatar withBlock:^(UIImage *image) {
        [_avatar setBackgroundImage:image forState:UIControlStateNormal];
    }];
    
    //    [_avatarView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:urlString_avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    //    _avatarView.isV = viewModel.isV;
    
    _content.text = viewModel.content;
    [_username setTitle:viewModel.username forState:UIControlStateNormal];
    
}

@end
