//
//  ATOMAccountTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMAccountSettingTableViewCell.h"

@implementation ATOMAccountSettingTableViewCell

static int padding28 = 28;
static int padding13 = 13;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding28, padding13, 120, 19)];
    [self addSubview:_themeLabel];
}

- (void)addSwitch {
    _offlineDownloadSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - padding13 - 43, 7.5, 43, 30)];
    _offlineDownloadSwitch.onTintColor = [UIColor colorWithHex:0x00adef];
    [self addSubview:_offlineDownloadSwitch];
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
