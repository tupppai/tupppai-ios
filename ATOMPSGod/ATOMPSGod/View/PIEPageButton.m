//
//  PIEButton.m
//  TUPAI
//
//  Created by chenpeiwei on 9/25/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEPageButton.h"
#import "POP.h"
@implementation PIEPageButton

-(void)awakeFromNib {

    _number = 0;
    _selected = NO;
    _imageView = [UIImageView new];
    _label = [UILabel new];
    _label.text = @"0";
    _label.font = [UIFont systemFontOfSize:13];
    _label.textColor = [UIColor lightGrayColor];
    [self addSubview:_imageView];
    [self addSubview:_label];
    
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@14);
        make.height.equalTo(@14);
        make.leading.equalTo(self);
        make.centerY.equalTo(self);
    }];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imageView.mas_trailing).with.offset(2);
        make.centerY.equalTo(_imageView);
        make.right.equalTo(self);
    }];
}

-(void)setSelected:(BOOL)selected {
    _imageView.highlighted = selected;
    _selected = selected;
    if (selected) {
        self.number++;
    } else {
        self.number--;
    }
    [self scaleAnimation];
}
-(void)setHighlighted:(BOOL)highlighted {
    _imageView.highlighted = highlighted;
    _selected = highlighted;
}
-(void)setNumber:(NSInteger)number {
    _number = number;
    _numberString = [NSString stringWithFormat:@"%zd",number];
    _label.text = [NSString stringWithFormat:@"%zd",number];
}

-(void)setNumberString:(NSString *)numberString {
    _number = [numberString integerValue];
    _numberString = numberString;
    _label.text = numberString;
}

- (void)scaleAnimation
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(10.f, 10.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.springBounciness = 12.0f;
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}
@end
