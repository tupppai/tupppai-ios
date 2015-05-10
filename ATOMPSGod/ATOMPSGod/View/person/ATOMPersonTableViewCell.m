//
//  ATOMPersonTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMPersonTableViewCell.h"

@interface ATOMPersonTableViewCell ()

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
    _themeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadding30, (CGHeight(self.frame) - 24) / 2, 24, 24)];
    _themeImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:_themeImageView];
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_themeImageView.frame) + kPadding20, (CGHeight(self.frame) - kFont14) / 2, kUserNameLabelWidth, kFont14)];
    _themeLabel.font = [UIFont systemFontOfSize:kFont14];
    [self addSubview:_themeLabel];
    
    _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kPadding30 - 11, (CGHeight(self.frame) - 24) / 2, 11, 24)];
    _arrowImageView.contentMode = UIViewContentModeCenter;
    _arrowImageView.image = [UIImage imageNamed:@"ic_right-arrow"];
    [self addSubview:_arrowImageView];
    
    _topLine = [[UIView alloc] initWithFrame:CGRectMake(kPadding30, 0, SCREEN_WIDTH - 2 * kPadding30, 0.5f)];
    _topLine.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.2];
    _topLine.hidden = YES;
    [self addSubview:_topLine];
    
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(kPadding30, CGRectGetHeight(self.frame) - 0.5f, SCREEN_WIDTH - 2 * kPadding30, 0.5)];
    _bottomLine.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.2];
    _bottomLine.hidden = YES;
    [self addSubview:_bottomLine];
}

- (void)addTopLine {
    _topLine.hidden = NO;
}

- (void)addBottomLine {
    _bottomLine.hidden = NO;
}















@end
