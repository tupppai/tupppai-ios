//
//  ATOMAccountTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMAccountSettingTableViewCell.h"

@implementation ATOMAccountSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.separatorInset = UIEdgeInsetsMake(0, kPadding28, 0, kPadding15);
        self.textLabel.textColor = [UIColor colorWithHex:0x737373];
    }
    return self;
}

- (void)addSwitch {
    _offlineDownloadSwitch = [UISwitch new];
    _offlineDownloadSwitch.onTintColor = [UIColor colorWithHex:0x00adef];
    self.accessoryView = _offlineDownloadSwitch;
}



@end
