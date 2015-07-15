//
//  ATOMMessageRemindTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMessageRemindTableViewCell.h"

@implementation ATOMMessageRemindTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, kPadding28, 0, kPadding15);
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
//    _themeLabel = [UILabel new];
//    _themeLabel.textColor = [UIColor colorWithHex:0x797979];
//    [self addSubview:_themeLabel];
//    [self.themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).with.offset(padding28);
//        make.centerY.equalTo(self);
//    }];
    self.textLabel.textColor = [UIColor colorWithHex:0x797979];
    _notificationSwitch = [UISwitch new];
    self.accessoryView = _notificationSwitch;
    _notificationSwitch.onTintColor = [UIColor colorWithHex:0x00adef];
}


@end
