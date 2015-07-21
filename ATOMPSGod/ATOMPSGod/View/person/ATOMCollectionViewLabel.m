//
//  ATOMCollectionViewLabel.m
//  ATOMPSGod
//
//  Created by atom on 15/5/1.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCollectionViewLabel.h"

@interface ATOMCollectionViewLabel ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ATOMCollectionViewLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.image = [[UIImage imageNamed:@"pic_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadding5, 6, 13, 13)];
    [self addSubview:_imageView];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame) + kPadding5, 0, CGWidth(self.frame) / 2, CGHeight(self.frame))];
    _label.font = [UIFont systemFontOfSize:kFont10];
    [self addSubview:_label];
}

- (void)setNumber:(NSString *)number {
    _number = number;
    _label.text = number;
}

- (void)setColorType:(NSInteger)colorType {
    _colorType = colorType;
    if (colorType) {
        _imageView.image = [UIImage imageNamed:@"pswork_blue"];
        _label.textColor = [UIColor colorWithHex:0x74c3ff];
    } else {
        _imageView.image = [UIImage imageNamed:@"pswork_grey"];
        _label.textColor = [UIColor colorWithHex:0xacbbc1];
    }
}





























@end
