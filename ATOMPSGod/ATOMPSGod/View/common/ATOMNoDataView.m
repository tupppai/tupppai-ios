//
//  ATOMNoDataView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMNoDataView.h"

@interface ATOMNoDataView ()


@end

@implementation ATOMNoDataView


- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _imageView = [UIImageView new];
    _imageView.image = [UIImage imageNamed:@"ic_cry"];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
    
    _label = [UILabel new];
    _label.text = @"这里空空如也...";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:20.f];
    _label.textColor = [UIColor colorWithHex:0xadadad];
    [self addSubview:_label];
    self.imageView.frame = CGRectMake(0,0, 100, 100);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).with.offset(4);
        make.centerX.equalTo(self.imageView);
        make.size.mas_equalTo(CGSizeMake(150, 22));
    }];
}



@end
