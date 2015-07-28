//
//  ATOMPersonTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMPersonTableViewCell.h"

@interface ATOMPersonTableViewCell ()

@property (nonatomic, strong) UIImageView *themeImageView;
@property (nonatomic, strong) UILabel *themeLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation ATOMPersonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.themeImageView];
        [self addSubview:self.themeLabel];
        [self addSubview:self.arrowImageView];
        [self addSubview:self.topLine];
        [self addSubview:self.bottomLine];
        [self configLayout];
    }
    return self;
}

#pragma mark - Layout

- (void)configLayout {
    [self.themeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kPadding30);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_themeImageView.mas_right).with.offset(kPadding20);
        make.centerY.equalTo(self);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-kPadding30);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(11, 24));
    }];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kPadding30);
        make.right.equalTo(self).with.offset(-kPadding30);
        make.top.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kPadding30);
        make.right.equalTo(self).with.offset(-kPadding30);
        make.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - Public Method

- (void)addTopLine:(BOOL)flag {
    _topLine.hidden = !flag;
}

- (void)addBottomLine:(BOOL)flag {
    _bottomLine.hidden = !flag;
}

- (void)configThemeImageWith:(UIImage *)image {
    self.themeImageView.image = image;
}

- (void)configThemeLabelWith:(NSString *)str {
    self.themeLabel.text = str;
}

#pragma mark - Getter & Setter

- (UIImageView *)themeImageView {
    if (!_themeImageView) {
        _themeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _themeImageView.contentMode = UIViewContentModeCenter;
    }
    return _themeImageView;
}

- (UILabel *)themeLabel {
    if (!_themeLabel) {
        _themeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _themeLabel.font =  [UIFont systemFontOfSize:16];
        _themeLabel.textColor = [UIColor colorWithHex:0x737373];
    }
    return _themeLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _arrowImageView.contentMode = UIViewContentModeCenter;
        _arrowImageView.image = [UIImage imageNamed:@"ic_right-arrow"];
    }
    return _arrowImageView;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] initWithFrame:CGRectZero];
        _topLine.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.2];
    }
    return _topLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.2];
    }
    return _bottomLine;
}




































@end
