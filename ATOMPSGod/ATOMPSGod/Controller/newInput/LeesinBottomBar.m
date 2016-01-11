//
//  PIETextToolBar.m
//  PIEGrowingTextInput
//
//  Created by chenpeiwei on 1/5/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import "LeesinBottomBar.h"
#import "Masonry.h"
@implementation LeesinBottomBar

- (id)init
{
    if (self = [super init]) {
        [self pie_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self pie_commonInit];
    }
    return self;
}


- (void)pie_commonInit
{
    self.rightButtonType = LeesinBottomBarRightButtonTypeConfirmDisable;
    self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [self addSubview:self.button_album];
    [self addSubview:self.button_shoot];
    [self addSubview:self.button_confirm];
    [self addSubview:self.label_confirmedCount];
    [self pie_setupViewConstraints];
}

- (void) pie_setupViewConstraints {
//    CGSize buttonSize1 = [self pie_appropriateButtonSize:self.button_album];
//    CGSize buttonSize2 = [self pie_appropriateButtonSize:self.button_shoot];
//    CGSize buttonSize3 = [self pie_appropriateButtonSize:self.button_confirm];

    [self.button_album mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(buttonSize1.width));
//        make.height.equalTo(@(buttonSize1.height));
        make.leading.equalTo(@12).with.priorityHigh();
        make.centerY.equalTo(self);
    }];
    [self.button_shoot mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(buttonSize2.width));
//        make.height.equalTo(@(buttonSize2.height));
        make.leading.equalTo(self.button_album.mas_trailing).with.offset(17).with.priorityHigh();
        make.centerY.equalTo(self);
    }];
    [self.button_confirm mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(buttonSize3.width));
//        make.height.equalTo(@(buttonSize3.height));
        make.trailing.equalTo(self).with.offset(-12).with.priorityHigh();
        make.centerY.equalTo(self);
    }];
    [self.label_confirmedCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.button_confirm.mas_leading).with.offset(-8);
        make.centerY.equalTo(self);
        make.width.greaterThanOrEqualTo(@(self.label_confirmedCount.font.lineHeight + 2.5));
        make.height.equalTo(@(self.label_confirmedCount.font.lineHeight + 2.5));

    }];
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.label_confirmedCount.layer.cornerRadius = self.label_confirmedCount.frame.size.width/2;
    self.label_confirmedCount.clipsToBounds = YES;
}


-(void)setRightButtonType:(LeesinBottomBarRightButtonType)rightButtonType {
    if (_rightButtonType == rightButtonType) {
        return;
    }
    _rightButtonType = rightButtonType;
    switch (rightButtonType) {
        case LeesinBottomBarRightButtonTypeCancelEnable:
            [self.button_confirm setTitle:@"取消" forState:UIControlStateNormal];
            self.button_confirm.alpha = 0.5;
            self.button_confirm.enabled = YES;
            break;
        case LeesinBottomBarRightButtonTypeConfirmDisable:
            [self.button_confirm setTitle:@"确定" forState:UIControlStateNormal];
            self.button_confirm.alpha = 0.5;
            self.button_confirm.enabled = NO;
            break;
        case LeesinBottomBarRightButtonTypeConfirmEnable:
            [self.button_confirm setTitle:@"确定" forState:UIControlStateNormal];
            self.button_confirm.alpha = 1.0;
            self.button_confirm.enabled = YES;
            break;
        default:
            break;
    }
}
//- (CGSize)pie_appropriateButtonSize:(UIButton*)button
//{
//    //    if (self.autoHideRightButton) {
//    //        if (self.textView.text.length == 0) {
//    //            return 0.0;
//    //        }
//    //    }
//    
//    NSString *title = [button titleForState:UIControlStateNormal];
//    
//    CGSize buttonSize;
//    
//    if ([title length] == 0 && button.imageView.image) {
//        buttonSize = button.imageView.image.size;
//    }
//    else {
//        buttonSize = [title sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
//    }
//    
//    return buttonSize ;
//}

-(UIButton *)button_album {
    if (!_button_album) {
        _button_album = [UIButton buttonWithType:UIButtonTypeSystem];
        _button_album.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_button_album setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_button_album setTitle:@"相册" forState:UIControlStateNormal];
    }
    return _button_album;
}

-(UIButton *)button_shoot {
    if (!_button_shoot) {
        _button_shoot = [UIButton buttonWithType:UIButtonTypeSystem];
        _button_shoot.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_button_shoot setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_button_shoot setTitle:@"拍照" forState:UIControlStateNormal];
    }
    return _button_shoot;
}
-(UIButton *)button_confirm {
    if (!_button_confirm) {
        _button_confirm = [UIButton buttonWithType:UIButtonTypeSystem];
        _button_confirm.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_button_confirm setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_button_confirm setTitle:@"确定" forState:UIControlStateNormal];
        _button_confirm.enabled = NO;
        _button_confirm.alpha = 0.3;
        _button_confirm.hidden = YES;
    }
    return _button_confirm;
}

-(UILabel *)label_confirmedCount {
    if (!_label_confirmedCount) {
        _label_confirmedCount = [UILabel new];
        _label_confirmedCount.font = [UIFont systemFontOfSize:12.0];
        _label_confirmedCount.backgroundColor = [UIColor orangeColor];
        _label_confirmedCount.text = @"0";
        _label_confirmedCount.textAlignment = NSTextAlignmentCenter;
        _label_confirmedCount.hidden = YES;
    }
    return _label_confirmedCount;
}

-(void)setType:(LeeSinBottomBarType)type {
    _type = type;
    if (type == LeeSinBottomBarTypeReplyPHAsset) {
        [_button_album setTitle:@"相册" forState:UIControlStateNormal];
        _button_shoot.hidden = YES;
        _label_confirmedCount.hidden = YES;
    } else if (type == LeeSinBottomBarTypeReplyMission) {
        [_button_album setTitle:@"历史任务" forState:UIControlStateNormal];
        _button_shoot.hidden = YES;
        _label_confirmedCount.hidden = YES;
    } else if (type == LeeSinBottomBarTypeAsk) {
        [_button_album setTitle:@"相册" forState:UIControlStateNormal];
    }
    else if (type == LeeSinBottomBarTypeReplyNoMissionSelection) {
        [_button_album setTitle:@"相册" forState:UIControlStateNormal];
        _button_shoot.hidden = YES;
        _label_confirmedCount.hidden = YES;
    }
}


@end
