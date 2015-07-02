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
        [self createSubView];
        self.separatorInset = UIEdgeInsetsMake(0, kPadding28, 0, kPadding15);
    }
    return self;
}

- (void)createSubView {
    _themeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _themeLabel.font =  [UIFont fontWithName:@"Hiragino Sans GB W3" size:kFont14];
    _themeLabel.textColor = [UIColor darkGrayColor];
    //should always add subview to self before makeConstraints!
    [self addSubview:_themeLabel];
    [self.themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kPadding28);
        make.centerY.equalTo(self);
    }];
}

- (void)addSwitch {
    _offlineDownloadSwitch = [UISwitch new];
    _offlineDownloadSwitch.onTintColor = [UIColor colorWithHex:0x00adef];
    self.accessoryView = _offlineDownloadSwitch;
}

- (void)addArrow {
    
}

- (void)addLogout {
    [_themeLabel removeFromSuperview];
    self.backgroundColor = [UIColor colorWithHex:0x00adef];
    _logoutLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    _logoutLabel.text = @"退出当前账号";
    _logoutLabel.textAlignment = NSTextAlignmentCenter;
    _logoutLabel.textColor = [UIColor whiteColor];
    [self addSubview:_logoutLabel];
}








@end
