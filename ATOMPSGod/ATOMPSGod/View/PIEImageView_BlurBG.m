//
//  PIEImageView_BlurBG.m
//  TUPAI
//
//  Created by chenpeiwei on 11/28/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEImageView_BlurBG.h"
#import "FXBlurView.h"

@interface PIEImageView_BlurBG ()
@property (nonatomic,strong) UIImageView* imageView;
@property (nonatomic,strong) UIImageView* imageView_blur;
@end

@implementation PIEImageView_BlurBG

-(instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.imageView_blur];
        [self addSubview:self.imageView];
//        [self.imageView_blur mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self);
//            make.bottom.equalTo(self);
//            make.leading.equalTo(self);
//            make.trailing.equalTo(self);
//        }];
//        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self);
//            make.bottom.equalTo(self);
//            make.leading.equalTo(self);
//            make.trailing.equalTo(self);
//        }];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addSubview:self.imageView_blur];
        [self addSubview:self.imageView];
        [self.imageView_blur mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
        }];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
        }];
    }
    return self;
}
-(void)setImage:(UIImage *)image {
    self.imageView.image = image;
    self.imageView_blur.image = [image blurredImageWithRadius:80 iterations:1 tintColor:[UIColor blackColor]];
}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView.hidden = YES;
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = [UIImage imageNamed:@"cellHolder"];
        _imageView.frame = self.bounds;
    }
    return _imageView;
}
-(UIImageView *)imageView_blur {
    if (!_imageView_blur) {
        _imageView_blur = [UIImageView new];
        _imageView_blur.contentMode = UIViewContentModeScaleAspectFill;
        _imageView_blur.clipsToBounds = YES;
        _imageView_blur.frame = self.bounds;
    }
    return _imageView_blur;
}
@end
