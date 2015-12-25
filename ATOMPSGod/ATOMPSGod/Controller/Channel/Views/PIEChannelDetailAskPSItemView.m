//
//  PIEChannelDetailAskPSItemView.m
//  TUPAI
//
//  Created by huangwei on 15/12/9.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelDetailAskPSItemView.h"

@implementation PIEChannelDetailAskPSItemView
-(void)awakeFromNib {
    
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview: self.label];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self);
            make.top.equalTo(self);
            make.trailing.equalTo(self).with.offset(-10);
            make.width.equalTo(self.imageView.mas_height);
        }];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo (self.imageView.mas_bottom).with.offset(4);
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.bottom.equalTo (self);
        }];
    }
    return self;
}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}
-(UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.font = [UIFont lightTupaiFontOfSize:12];
        _label.textColor = [UIColor darkGrayColor];
        _label.minimumScaleFactor = 0.5;
    }
    return _label;
}
@end
