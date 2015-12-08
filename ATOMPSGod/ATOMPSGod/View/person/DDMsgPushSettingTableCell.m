//
//  ATOMMessageRemindTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDMsgPushSettingTableCell.h"

@implementation DDMsgPushSettingTableCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, kPadding28, 0, kPadding15);
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.font = [UIFont lightTupaiFontOfSize:14];    
    _notificationSwitch = [UISwitch new];
    self.accessoryView = _notificationSwitch;
    _notificationSwitch.onTintColor = [UIColor colorWithHex:PIEColorHex];
}


@end
