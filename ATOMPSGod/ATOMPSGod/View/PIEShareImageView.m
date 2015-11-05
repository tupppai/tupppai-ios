//
//  PIEShareImageView.m
//  TUPAI
//
//  Created by chenpeiwei on 11/5/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEShareImageView.h"
#import "PIEImageEntity.h"
@interface PIEShareImageView()
@property (nonatomic,strong) UIView* bottomView;
@property (nonatomic,assign) NSInteger height;

@end

@implementation PIEShareImageView

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
        [self mansory];
    }
    return self;
}
- (void)setupViews {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.avatarView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.imageView];
    [self addSubview:self.bottomView];
    [self addSubview:self.QRCodeView];
    [self addSubview:self.label];
    [self addSubview:self.label2];
    [self addSubview:self.imageView_thumb_bg];
    [self addSubview:self.imageView_thumb];
    [self addSubview:self.imageView_type];
    [self addSubview:self.imageView_appIcon];
    _height = 33+20+14+44+100;
}
- (void)mansory {
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.leading.equalTo(self).with.offset(33);
        make.top.equalTo(self).with.offset(33);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.avatarView.mas_trailing).with.offset(7);
        make.trailing.equalTo(self).with.offset(-10);
        make.centerY.equalTo(self.avatarView);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).with.offset(36);
        make.top.equalTo(self.avatarView.mas_bottom).with.offset(14);
        make.trailing.equalTo(self).with.offset(-46);
    }];
    [self.imageView_thumb_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@105);
        make.height.equalTo(@105);
        make.trailing.equalTo(self.imageView).with.offset(35);
        make.bottom.equalTo(self.imageView).with.offset(20);
        make.bottom.lessThanOrEqualTo(self.bottomView.mas_top).with.offset(-44);
    }];

    [self.imageView_thumb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@93);
        make.height.equalTo(@93);
        make.center.equalTo(self.imageView_thumb_bg);
    }];
    
    [self.imageView_type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@32);
        make.height.equalTo(@17);
        make.top.equalTo(self.imageView_thumb);
        make.leading.equalTo(self.imageView_thumb);
    }];
    

    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@100);
    }];
    [self.QRCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@60);
        make.height.equalTo(@60);
        make.trailing.equalTo(self.bottomView).with.offset(-30);
        make.top.equalTo(self.bottomView).with.offset(20);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.QRCodeView);
        make.trailing.equalTo(self.QRCodeView.mas_leading).with.offset(-4);
    }];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QRCodeView.mas_bottom).with.offset(4);
        make.trailing.equalTo(self.QRCodeView).with.offset(-3);
    }];
    
    [self.imageView_appIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@11);
        make.height.equalTo(@11);
        make.top.equalTo(self.label2).with.offset(1);
        make.centerX.equalTo(self.label2).with.offset(6);
    }];
    
}
-(void)injectSauce:(DDPageVM*)vm withBlock:(void(^)(BOOL success))block {
    _nameLabel.text = vm.username;
    
    [DDService downloadImage:vm.imageURL withBlock:^(UIImage *image) {
        if (!image) {
            block(NO);
        }
        _imageView.image = image;
        [self adjustHeight:image.size];
        
        [DDService downloadImage:vm.avatarURL withBlock:^(UIImage *image) {
            _avatarView.image = image;
            if (vm.type == PIEPageTypeReply) {
                if (vm.thumbEntityArray.count>0) {
                    PIEImageEntity* entity = [vm.thumbEntityArray objectAtIndex:0];
                    [DDService downloadImage:entity.url withBlock:^(UIImage *image) {
                        _imageView_thumb.image = image;
                        _imageView_thumb.hidden = NO;
                        block(YES);
                    }];
                }
            }
        }];
    }];
}

- (void)adjustHeight:(CGSize)size {
    CGFloat scale = size.height/size.width;
    NSInteger finalHeight = (SCREEN_WIDTH-46-36)*scale;
    if (finalHeight > (SCREEN_HEIGHT - _height) ) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, finalHeight+_height);
    }
//    [self setNeedsDisplay];
}
- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarView.clipsToBounds = YES;
        _avatarView.layer.cornerRadius = 10;
        _avatarView.clipsToBounds = YES;
//        _avatarView.image = [UIImage imageNamed:@"psps"];
    }
    return _avatarView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.text= @"peiwei";
        _nameLabel.textColor = [UIColor colorWithHex:0x010101];
    }
    return _nameLabel;
}
-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
//        _imageView.image = [UIImage imageNamed:@"psps"];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}
-(UIImageView *)imageView_thumb {
    if (!_imageView_thumb) {
        _imageView_thumb = [UIImageView new];
        _imageView_thumb.image = [UIImage imageNamed:@"psps"];
        _imageView_thumb.contentMode = UIViewContentModeScaleAspectFill;
        _imageView_thumb.clipsToBounds = YES;
//        _imageView_thumb.hidden = YES;
    }
    return _imageView_thumb;
}
-(UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
//        [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]
        _bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _bottomView;
}

-(UIImageView *)QRCodeView {
    if (!_QRCodeView) {
        _QRCodeView = [UIImageView new];
        _QRCodeView.backgroundColor = [UIColor lightGrayColor];
    }
    return _QRCodeView;
}
-(UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:13];
        _label.text= @"长按识别二维码\n看更多让你意想不到的照片";
        _label.textAlignment = NSTextAlignmentRight;
        _label.textColor = [UIColor colorWithHex:0x010101 andAlpha:0.8];
        _label.alpha = 0.8;
        _label.numberOfLines = 0;
    }
    return _label;
}
-(UILabel *)label2 {
    if (!_label2) {
        _label2 = [UILabel new];
        _label2.font = [UIFont systemFontOfSize:10];
        _label2.text= @"分享自        图派";
        _label2.textAlignment = NSTextAlignmentRight;
        _label2.textColor = [UIColor colorWithHex:0x010101 andAlpha:0.5];
        _label2.alpha = 0.5;
    }
    return _label2;
}

-(UIImageView *)imageView_type {
    if (!_imageView_type) {
        _imageView_type = [UIImageView new];
        _imageView_type.contentMode = UIViewContentModeTopLeft;
        _imageView_type.image = [UIImage imageNamed:@"pie_origin"];
    }
    return _imageView_type;
}
-(UIView *)imageView_thumb_bg {
    if (!_imageView_thumb_bg) {
        _imageView_thumb_bg = [UIView new];
        _imageView_thumb_bg.backgroundColor = [UIColor colorWithHex:0xf0f0f0];
        _imageView_thumb_bg.layer.borderColor = [UIColor colorWithHex:0xeeeeee andAlpha:0.2].CGColor;
        _imageView_thumb_bg.layer.borderWidth = 1.0;
    }
    return _imageView_thumb_bg;
}
-(UIImageView *)imageView_appIcon {
    if (!_imageView_appIcon) {
        _imageView_appIcon = [UIImageView new];
        _imageView_appIcon.contentMode = UIViewContentModeScaleAspectFit;
        _imageView_appIcon.image = [UIImage imageNamed:@"pie_appIcon"];
    }
    return _imageView_appIcon;
}
@end


