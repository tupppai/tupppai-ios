//
//  PIEThumbAnimateView2.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/14/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEThumbAnimateView.h"

@implementation PIEThumbAnimateView
-(instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 100, 100);
        _toExpand = YES;
        _shrinkedSize = CGSizeMake(100, 100);
        _expandedSize = CGSizeMake(SCREEN_WIDTH, 300);
        _leftView.contentMode = UIViewContentModeScaleAspectFill;
        _rightView.contentMode = UIViewContentModeScaleAspectFill;
        _leftView.clipsToBounds = YES;
        _rightView.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        _leftView = [UIImageView new];
        _leftView.image = [UIImage imageNamed:@"test1"];
        _rightView = [UIImageView new];
        _rightView.image = [UIImage imageNamed:@"psps"];
        [self addSubview:_leftView];
        [self addSubview:_rightView];

        [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.trailing.equalTo(self);
            make.bottom.equalTo(self);
        }];
        [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)setSubviewCounts:(NSInteger)subviewCounts {
    if (subviewCounts == 2) {
        [_rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.trailing.equalTo(self);
            make.bottom.equalTo(self);
            make.width.equalTo(self).with.multipliedBy(0.5);
        }];
        [_leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self);
            make.bottom.equalTo(self);
            make.width.equalTo(self).with.multipliedBy(0.5);
        }];

    }
    else {
        [_rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.trailing.equalTo(self);
            make.bottom.equalTo(self);
            make.width.equalTo(self).with.multipliedBy(1);
        }];
        [_leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self);
            make.bottom.equalTo(self);
            make.width.equalTo(self).with.multipliedBy(0);
        }];
    }
    [self layoutIfNeeded];
}


//- (void)toggleExpanded {
//    
//    if (_toExpand) {
//        [self mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@(_expandedSize.width)).with.priorityHigh();
//            make.height.equalTo(@(_expandedSize.height)).with.priorityHigh();
//        }];
//    } else {
//        [self mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@(_shrinkedSize.width)).with.priorityHigh();
//            make.height.equalTo(@(_shrinkedSize.height)).with.priorityHigh();
//        }];
//    }
//    [UIView animateWithDuration:0.6 animations:^{
//        [self layoutIfNeeded];
//    }];
//    _toExpand = !_toExpand;
//    NSLog(@"self %@",NSStringFromCGRect(self.frame));
//    
//}


@end
