//
//  PIEPageLikeButton.m
//  TUPAI
//
//  Created by chenpeiwei on 9/26/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEPageLikeButton.h"
#import "POP.h"
@implementation PIEPageLikeButton

-(void)awakeFromNib {
    _selected = NO;
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _label = [PIEHighlightableLabel new];
    [self addSubview:_imageView];
    [self addSubview:_label];
    _imageView.image = [UIImage imageNamed:@"pieLike"];
    _imageView.highlightedImage = [UIImage imageNamed:@"pieLike_selected"];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@15);
        make.height.equalTo(@15);
        make.leading.equalTo(self);
        make.centerY.equalTo(self);
    }];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imageView.mas_trailing).with.offset(1);
        make.top.equalTo(_imageView).with.offset(-3);
        make.width.greaterThanOrEqualTo(@13);
    }];
}
-(instancetype)init {
    self = [super init];
    if (self) {
        _selected = NO;
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _label = [PIEHighlightableLabel new];
        [self addSubview:_imageView];
        [self addSubview:_label];
        _imageView.image = [UIImage imageNamed:@"pieLike"];
        _imageView.highlightedImage = [UIImage imageNamed:@"pieLike_selected"];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@15);
            make.height.equalTo(@15);
            make.leading.equalTo(self);
            make.centerY.equalTo(self);
        }];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_imageView.mas_trailing).with.offset(1);
            make.top.equalTo(_imageView).with.offset(-3);
            make.width.greaterThanOrEqualTo(@13);
        }];
    }
    return self;
}
-(void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    _selected = highlighted;
    _imageView.highlighted = highlighted;
    _label.highlighted= highlighted;
    
}

//selected toggle color and number
-(void)setSelected:(BOOL)selected {
    _highlighted = selected;
    _selected = selected;
    _imageView.highlighted = selected;
    _label.selected= selected;
    [self scaleAnimation];
}

-(void)setNumber:(NSInteger)number {
    _number = number;
    _numberString = [NSString stringWithFormat:@"%zd",number];
    _label.number = number;
}

-(void)setNumberString:(NSString *)numberString {
    _number = [numberString integerValue];
    _numberString = numberString;
    _label.numberString = numberString;
}

- (void)scaleToSmall
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.95f, 0.95f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
}
- (void)scaleToBig
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.25f, 1.25f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleBigAnimation"];
}

- (void)scaleAnimation
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(10.f, 10.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.springBounciness = 12.0f;
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}

- (void)scaleToDefault
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleDefaultAnimation"];
}

@end
