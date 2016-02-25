//
//  PIEImageView.m
//  TUPAI
//
//  Created by chenpeiwei on 10/16/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEImageView.h"
//@interface PIEImageView()
//@property (nonatomic,assign) CGSize* size;
//@end
@implementation PIEImageView

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.thumbImageView];
        [self mansory];
    }
    return self;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.thumbImageView];
        [self mansory];
    }
    return self;
}


-(instancetype)initWithImageName:(NSString*)imageName thumbImageName:(NSString*)thumbImageName thumbSize:(CGSize*)size {
    self = [self init];
    if (self) {
        self.imageView.image = [UIImage imageNamed:imageName];
        self.thumbImageView.image = [UIImage imageNamed:thumbImageName];
        [self.thumbImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(size->width));
            make.height.equalTo(@(size->height));
        }];
    }
    return self;
}


-(instancetype)initWithImageName:(NSString*)imageName thumbImageName:(NSString*)thumbImageName {
    self = [self init];
    if (self) {
        self.imageView.image = [UIImage imageNamed:imageName];
        self.thumbImageView.image = [UIImage imageNamed:thumbImageName];
    }
    return self;
}


- (void)mansory {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imageView).with.offset(-1);
        make.top.equalTo(self.imageView).with.offset(-2);
        make.width.equalTo(self).with.multipliedBy(0.36);
        make.width.equalTo(self).with.multipliedBy(0.36);
//        make.height.equalTo(@15);
//        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.layer.cornerRadius = 4;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

-(UIImageView *)thumbImageView {
    if (!_thumbImageView) {
        _thumbImageView = [UIImageView new];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _thumbImageView;
}
@end
