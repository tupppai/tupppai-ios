//
//  ATOMMessageRemindTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMessageRemindTableViewCell.h"

@implementation ATOMMessageRemindTableViewCell

static int padding28 = 28;
static int padding13 = 13;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding28, padding13, 120, 19)];
    _themeLabel.textColor = [UIColor colorWithHex:0x797979];
    [self addSubview:_themeLabel];
    _offlineDownloadSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - padding13 - 43, 7.5, 43, 30)];
    _offlineDownloadSwitch.onTintColor = [UIColor colorWithHex:0x00adef];
    [self addSubview:_offlineDownloadSwitch];
}


@end
