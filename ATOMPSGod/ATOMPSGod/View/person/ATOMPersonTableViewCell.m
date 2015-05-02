//
//  ATOMPersonTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMPersonTableViewCell.h"

@interface ATOMPersonTableViewCell ()

@property (nonatomic, strong) UIView *topLine;

@end

@implementation ATOMPersonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _themeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadding30, 18, 24, 24)];
    _themeImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:_themeImageView];
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_themeImageView.frame) + kPadding20, 23, kUserNameLabelWidth, kFont14)];
    _themeLabel.font = [UIFont systemFontOfSize:kFont14];
    [self addSubview:_themeLabel];
    
    _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kPadding30, 18, 11, 24)];
    _arrowImageView.contentMode = UIViewContentModeCenter;
    _arrowImageView.image = [UIImage imageNamed:@"ic_right-arrow"];
    [self addSubview:_arrowImageView];
    
    _topLine = [[UIView alloc] initWithFrame:CGRectMake(kPadding30, 0, SCREEN_WIDTH - 2 * kPadding30, 0.5)];
    _topLine.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.2];
    [self addSubview:_topLine];
    
}


















@end
