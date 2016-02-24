//
//  PIEPageCollectionImageView.m
//  TUPAI
//
//  Created by chenpeiwei on 2/24/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEPageCollectionImageView.h"
@interface PIEPageCollectionImageView()
@property (nonatomic,strong) UIImageView* imageView;
@property (nonatomic,strong) UIImageView* tagImageView;
@end

@implementation PIEPageCollectionImageView
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];

        [self addSubview:self.imageView];
        [self addSubview:self.tagImageView];
        [self mansory];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.tagImageView];
        [self mansory];
    }
    return self;
}



-(void)setImage:(UIImage *)image {
    _imageView.image = image;
}
-(void)setImage_tag:(UIImage *)image_tag {
    _tagImageView.image = image_tag;
}

- (void)mansory {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imageView).with.offset(-2);
        make.top.equalTo(self.imageView).with.offset(-1);
        make.width.equalTo(self).with.multipliedBy(0.55);
    }];
}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

-(UIImageView *)tagImageView {
    if (!_tagImageView) {
        _tagImageView = [UIImageView new];
        _tagImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _tagImageView;
}
@end
