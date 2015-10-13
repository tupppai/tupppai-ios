//
//  PIEShareIcon.m
//  TUPAI
//
//  Created by chenpeiwei on 10/13/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEShareIcon.h"

@implementation PIEShareIcon
-(instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        [self mansory];
    }
    return self;
}

- (void)mansory {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(self.imageView.mas_width);
        make.top.equalTo(self);
        make.centerX.equalTo(self);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(@25);
        make.top.equalTo(self.imageView.mas_bottom);
        make.centerX.equalTo(self);
    }];

}
-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}
-(UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:11];
        _label.textColor = [UIColor darkGrayColor];
        _label.adjustsFontSizeToFitWidth = YES;
    }
    return _label;
}
@end
