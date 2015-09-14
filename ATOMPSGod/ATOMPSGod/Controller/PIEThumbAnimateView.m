//
//  PIEThumbAnimateView.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/14/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEThumbAnimateView.h"
@interface PIEThumbAnimateView()

@end
@implementation PIEThumbAnimateView


- (void)awakeFromNib {
    _toExpand = YES;
    _shrinkedSize = CGSizeMake(90, 90);
    _expandedSize = CGSizeMake(SCREEN_WIDTH, 300);
    _leftView.contentMode = UIViewContentModeScaleAspectFill;
    _rightView.contentMode = UIViewContentModeScaleAspectFill;
    _leftView.clipsToBounds = YES;
    _rightView.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
       [[[NSBundle mainBundle] loadNibNamed:@"PIEThumbAnimateView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)setSubviewCounts:(NSInteger)subviewCounts {
    if (subviewCounts == 2) {
        [_rightView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self).with.multipliedBy(0.5);
        }];
    } else {
        [_rightView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self);
        }];
    }
}
- (void)toggleExpanded {
    
    if (_toExpand) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(_expandedSize.width)).with.priorityHigh();
            make.height.equalTo(@(_expandedSize.height)).with.priorityHigh();
        }];
    } else {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(_shrinkedSize.width)).with.priorityHigh();
            make.height.equalTo(@(_shrinkedSize.height)).with.priorityHigh();
        }];
    }
    [UIView animateWithDuration:0.8 animations:^{
        [self layoutIfNeeded];
    }];
    _toExpand = !_toExpand;
    NSLog(@"self %@",NSStringFromCGRect(self.frame));

}


@end
