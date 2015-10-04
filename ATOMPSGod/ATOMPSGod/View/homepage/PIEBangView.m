//
//  PIEBangView.m
//  TUPAI
//
//  Created by chenpeiwei on 10/3/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEBangView.h"

@implementation PIEBangView
-(instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.bangView];
        [self addSubview:self.label];
        [self mansoryViews];
    }
    return self;
}
-(UIImageView *)bangView {
    if (!_bangView) {
        _bangView = [UIImageView new];
        _bangView.image = [UIImage imageNamed:@"pie_ask_help"];
        _bangView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bangView;
}
-(UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.text = @"BANG";
        _label.font = [UIFont systemFontOfSize:8.0];
    }
    return _label;
}
- (void)mansoryViews {
    [self.bangView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(self).multipliedBy(0.6);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self.bangView.mas_bottom);
    }];
}
@end
