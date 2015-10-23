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
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithHex:0xffffff andAlpha:0.95];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
    [self addSubview:self.originView];
    
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
        make.leading.equalTo(self);
    }];
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self);
        make.bottom.equalTo(self);
        make.trailing.equalTo(_rightView.mas_leading);
    }];
    [_originView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self);
        make.width.equalTo(@40);
        make.height.equalTo(@16);
    }];
}
- (UIImageView*)leftView {
    if (!_leftView) {
        _leftView = [UIImageView new];
        _leftView.contentMode = UIViewContentModeScaleAspectFit;
        _leftView.clipsToBounds = YES;
    }
    return _leftView;
}
- (UIImageView*)rightView {
    if (!_rightView) {
        _rightView = [UIImageView new];
        _rightView.contentMode = UIViewContentModeScaleAspectFit;
        _rightView.clipsToBounds = YES;
    }
    return _rightView;
}
- (UIImageView*)originView {
    if (!_originView) {
        _originView = [UIImageView new];
        _originView.image = [UIImage imageNamed:@"pie_origin"];
        _originView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _originView;
}
- (void)setSubviewCounts:(NSInteger)subviewCounts {
    _subviewCounts = subviewCounts;
    if (subviewCounts == 2) {
        [_rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.trailing.equalTo(self);
            make.bottom.equalTo(self);
            make.width.equalTo(self).with.multipliedBy(0.5).with.priorityLow();
        }];
        [_leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self);
            make.bottom.equalTo(self);
            make.trailing.equalTo(_rightView.mas_leading);
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
            make.width.equalTo(@0);
        }];
    }
    [self layoutIfNeeded];
}





@end
