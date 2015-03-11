//
//  ATOMMyMessageTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyMessageTableViewCell.h"

@implementation ATOMMyMessageTableViewCell

static int padding25 = 25;
static int padding10 = 10;
static int padding15 = 15;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _themeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding25, padding10, padding25, padding25)];
    _themeImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:_themeImageView];
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_themeImageView.frame) + padding15, padding10, 120, padding25)];
    _themeLabel.textColor = [UIColor colorWithHex:0x59595b];
    [self addSubview:_themeLabel];
}


































@end
