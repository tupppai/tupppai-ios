//
//  ATOMAccountTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATOMAccountSettingTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *themeLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UISwitch *offlineDownloadSwitch;
@property (nonatomic, strong) UILabel *logoutLabel;

- (void)addArrow;
- (void)addSwitch;
- (void)addLogout;

@end
