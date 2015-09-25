//
//  PIEButton.m
//  TUPAI
//
//  Created by chenpeiwei on 9/25/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEButton.h"

@implementation PIEButton

-(void)awakeFromNib {

    _number = 0;
    _selected = NO;
    _imageView = [UIImageView new];
    _label = [UILabel new];
    _label.text = @"0";
    _label.font = [UIFont systemFontOfSize:14];
    _label.textColor = [UIColor lightGrayColor];
    [self addSubview:_imageView];
    [self addSubview:_label];
    
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@15);
        make.height.equalTo(@15);
        make.leading.equalTo(self);
        make.centerY.equalTo(self);
    }];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imageView.mas_trailing).with.offset(1);
        make.centerY.equalTo(_imageView);
        make.right.equalTo(self);
    }];
}

-(void)setSelected:(BOOL)selected {
    _imageView.highlighted = selected;
    if (selected) {
        self.number++;
    } else {
        self.number--;
    }
}

-(void)setNumber:(NSInteger)number {
    _label.text = [NSString stringWithFormat:@"%zd",number];
}

@end
