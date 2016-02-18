//
//  PIEThumbAnimateView2.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/14/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEThumbAnimateView.h"
@interface PIEThumbAnimateView()
@property (nonatomic,strong) MASConstraint *masContraint_rightViewWidth;

@end
@implementation PIEThumbAnimateView
-(instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (void)commonInit {
    [self setupSubviews];
}
- (void)setupSubviews {
    [self addSubview:self.blurView];
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
    [self addSubview:self.originView];
    
    [self.blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self);
        make.leading.equalTo(self);
        make.trailing.equalTo(self.rightView.mas_leading);
    }];
    
    //default when thumb view has only 1
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self);
        make.trailing.equalTo(self);
        self.masContraint_rightViewWidth = make.width.equalTo(self.mas_width).priorityLow();
    }];

    [self.originView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(-1);
        make.leading.equalTo(self).with.offset(-3);
        make.width.equalTo(@34);
        make.height.equalTo(@16);
    }];
}




-(UIImageView *)blurView {
    if (!_blurView) {
        _blurView = [UIImageView new];
        _blurView.contentMode = UIViewContentModeScaleAspectFill;
        _blurView.clipsToBounds = YES;
        _blurView.backgroundColor = [UIColor whiteColor];
    }
    return _blurView;
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
    if (_subviewCounts == 2) {
        [self.masContraint_rightViewWidth uninstall];
        [self.rightView mas_updateConstraints:^(MASConstraintMaker *make) {
           self.masContraint_rightViewWidth = make.width.equalTo(self).multipliedBy(0.5).with.priorityLow();
        }];
    } else {
        [self.masContraint_rightViewWidth uninstall];
        [self.rightView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.masContraint_rightViewWidth = make.width.equalTo(self).multipliedBy(1).with.priorityLow();
        }];
    }
}

- (void)animateWithType:(PIEThumbAnimateViewType)type {
    
    //变小
    if (_subviewCounts == 2) {
        if (self.enlarged) {
            [self.masContraint_rightViewWidth uninstall];
            [self.rightView mas_updateConstraints:^(MASConstraintMaker *make) {
                self.masContraint_rightViewWidth = make.width.equalTo(self).multipliedBy(0.5);
            }];
        } else {
            if (type == PIEThumbAnimateViewTypeLeft) {
                [self.masContraint_rightViewWidth uninstall];
                [self.rightView mas_updateConstraints:^(MASConstraintMaker *make) {
                    self.masContraint_rightViewWidth = make.width.equalTo(@0);
                }];
            } else {
                [self.masContraint_rightViewWidth uninstall];
                [self.rightView mas_updateConstraints:^(MASConstraintMaker *make) {
                    self.masContraint_rightViewWidth = make.width.equalTo(self);
                }];
            }
        }
        
    }
    self.enlarged = !self.enlarged;

}


- (void)renewContraints {
    if (self.enlarged) {
        if (_subviewCounts == 2) {
            [self.masContraint_rightViewWidth uninstall];
            [self.rightView mas_updateConstraints:^(MASConstraintMaker *make) {
                self.masContraint_rightViewWidth = make.width.equalTo(self).multipliedBy(0.5).with.priorityLow();
            }];
        }
        self.enlarged = NO;
    }
}

@end
