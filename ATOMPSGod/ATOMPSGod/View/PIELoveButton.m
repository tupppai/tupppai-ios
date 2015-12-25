//
//  PIELoveButton.m
//  TUPAI
//
//  Created by chenpeiwei on 12/25/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIELoveButton.h"
#import "POP.h"

@implementation PIELoveButton

-(void)awakeFromNib {
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _label = [PIELoveLabel new];
    [self addSubview:_imageView];
    [self addSubview:_label];
    _imageView.image = [UIImage imageNamed:@"pieLike"];
    _imageView.highlightedImage = [UIImage imageNamed:@"pieLike_selected"];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@18);
        make.height.equalTo(@18);
        make.leading.equalTo(self);
        make.centerY.equalTo(self);
    }];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imageView.mas_trailing).with.offset(1);
        make.top.equalTo(_imageView).with.offset(-3);
        make.width.greaterThanOrEqualTo(@12);
        make.height.equalTo(@12);
        make.trailing.equalTo(self);
    }];
}
-(void)setImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(imageSize.width));
        make.height.equalTo(@(imageSize.height));
        make.leading.equalTo(self);
        make.centerY.equalTo(self);
    }];
}
-(instancetype)init {
    self = [super init];
    if (self) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _label = [PIELoveLabel new];
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
            make.leading.equalTo(_imageView.mas_trailing).with.offset(1).with.priorityHigh();
            make.top.equalTo(_imageView).with.offset(-3);
            make.width.greaterThanOrEqualTo(@12);
            make.height.equalTo(@12);
            make.trailing.equalTo(self).with.priorityMedium();
        }];
    }
    return self;
}

- (void)initStatus :(PIELoveButtonStatus)status numberString:(NSString*)numberString {
    self.status = status;
    self.numberString = numberString;
}

- (void)commitStatus {
    switch (self.status) {
        case PIELoveButtonStatusNormal:
            self.status = PIELoveButtonStatusSelectedLow;
            break;
        case PIELoveButtonStatusSelectedLow:
            self.status = PIELoveButtonStatusSelectedMedium;
            
            break;
        case PIELoveButtonStatusSelectedMedium:
            self.status = PIELoveButtonStatusSelectedHigh;
            
            break;
        case PIELoveButtonStatusSelectedHigh:
            self.status = PIELoveButtonStatusNormal;
            
            break;
        default:
            break;
    }

    [_label commitCount];
    self.number = _label.number;
}

- (void)revertStatus {
    switch (self.status) {
        case PIELoveButtonStatusNormal:
            self.status = PIELoveButtonStatusSelectedHigh;
            break;
        case PIELoveButtonStatusSelectedLow:
            self.status = PIELoveButtonStatusNormal;
            
            break;
        case PIELoveButtonStatusSelectedMedium:
            self.status = PIELoveButtonStatusSelectedLow;
            
            break;
        case PIELoveButtonStatusSelectedHigh:
            self.status = PIELoveButtonStatusSelectedMedium;
            
            break;
        default:
            break;
    }
    
    [_label revertCount];
    self.number = _label.number;

}

- (void)setStatus:(PIELoveButtonStatus)status {
    _status = status;
    _label.status = status;
    switch (status) {
        case PIELoveButtonStatusNormal:
            self.imageView.image = [UIImage imageNamed:@"love_normal"];
            break;
        case PIELoveButtonStatusSelectedLow:
            self.imageView.image = [UIImage imageNamed:@"love_selected_low"];
            
            break;
        case PIELoveButtonStatusSelectedMedium:
            self.imageView.image = [UIImage imageNamed:@"love_selected_medium"];
            
            break;
        case PIELoveButtonStatusSelectedHigh:
            self.imageView.image = [UIImage imageNamed:@"love_selected_high"];
            
            break;
        default:
            break;
    }
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

//- (void)scaleToSmall
//{
//    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.95f, 0.95f)];
//    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
//}
//- (void)scaleToBig
//{
//    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.25f, 1.25f)];
//    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleBigAnimation"];
//}
//
//- (void)scaleAnimation
//{
//    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(10.f, 10.f)];
//    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
//    scaleAnimation.springBounciness = 12.0f;
//    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
//}
//
//- (void)scaleToDefault
//{
//    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
//    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleDefaultAnimation"];
//}


@end
