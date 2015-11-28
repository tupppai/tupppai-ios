//
//  PIECarousel_ItemView.m
//  TUPAI
//
//  Created by chenpeiwei on 11/26/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIECarousel_ItemView.h"

@implementation PIECarousel_ItemView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _imageView_type.contentMode = UIViewContentModeScaleAspectFit;
        _button_avatar.imageView.contentMode = UIViewContentModeScaleAspectFill;
        _button_avatar.layer.cornerRadius = _button_avatar.frame.size.width/2;
        _button_avatar.clipsToBounds = YES;
        _pageButton_comment.imageView.image = [UIImage imageNamed:@"hot_comment"];
        _pageButton_share.imageView.image   = [UIImage imageNamed:@"hot_share"];
        
        _button_name.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _label_time.textAlignment = NSTextAlignmentRight;

        [_button_avatar setTitleColor:[UIColor colorWithHex:0x000000 andAlpha:0.9] forState:UIControlStateNormal];
        [_button_avatar.titleLabel setFont:[UIFont lightTupaiFontOfSize:13]];
        
        [_label_content setTintColor:[UIColor colorWithHex:0x000000 andAlpha:0.8]];
        [_label_time setTintColor:[UIColor colorWithHex:0x000000 andAlpha:0.4]];
        [_label_content setFont:[UIFont lightTupaiFontOfSize:15]];
        [_label_time setFont:[UIFont lightTupaiFontOfSize:10]];

    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setVm:(PIEPageVM *)vm {
    if (_vm != vm) {
        _vm = vm;
    }
    _pageButton_comment.numberString = vm.commentCount;
    _pageButton_share.numberString = vm.shareCount;
    _label_time.text = vm.publishTime;
    _label_content.text = vm.content;
    [_button_name setTitle:vm.username forState:UIControlStateNormal];
    [_button_avatar setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:vm.avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    if (vm.type == PIEPageTypeAsk) {
        _imageView_type.image = [UIImage imageNamed:@"carousel_type_ask"];
        _pageLikeButton.hidden = YES;
    } else {
        _imageView_type.image = [UIImage imageNamed:@"carousel_type_reply"];
        _pageLikeButton.hidden = NO;
        _pageLikeButton.highlighted = vm.liked;
        _pageLikeButton.numberString = vm.likeCount;
    }
    
//    [_imageView_page setImageWithURL:[NSURL URLWithString:vm.imageURL] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
    [DDService downloadImage:vm.imageURL withBlock:^(UIImage *image) {
        _view_pageImage.image = image;
    }];
}
//@property (weak, nonatomic) IBOutlet UIImageView *imageView_type;
//@property (weak, nonatomic) IBOutlet UIButton *button_name;
//@property (weak, nonatomic) IBOutlet UILabel *label_time;
//@property (weak, nonatomic) IBOutlet UIButton *button_avatar;
//@property (weak, nonatomic) IBOutlet UIImageView *imageView_page;
//@property (weak, nonatomic) IBOutlet UILabel *label_content;
//@property (weak, nonatomic) IBOutlet PIEPageButton *pageButton_share;
//@property (weak, nonatomic) IBOutlet PIEPageButton *pageButton_comment;
//@property (weak, nonatomic) IBOutlet PIEPageLikeButton *pageLikeButton;

@end
