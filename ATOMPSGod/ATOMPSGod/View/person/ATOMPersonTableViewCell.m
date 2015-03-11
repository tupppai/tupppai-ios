//
//  ATOMPersonTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMPersonTableViewCell.h"

@implementation ATOMPersonTableViewCell

static int padding25 = 25;
static int padding15 = 15;
static int padding10 = 10;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _themeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding25, padding10, 25, padding25)];
    _themeImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:_themeImageView];
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_themeImageView.frame) + padding15, padding10, 120, padding25)];
    [self addSubview:_themeLabel];
    
}

@end
