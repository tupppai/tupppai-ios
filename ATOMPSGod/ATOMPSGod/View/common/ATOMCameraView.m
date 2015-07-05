//
//  ATOMCameraView.m
//  ATOMPSGod
//
//  Created by atom on 15/5/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCameraView.h"

@interface ATOMCameraView ()

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *bottomView;

@end

static CGFloat BottomHeight = 215;

@implementation ATOMCameraView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.8];
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    CGFloat buttonHeight = 45;
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(kPadding5, CGHeight(self.frame) - BottomHeight, SCREEN_WIDTH - 2 * kPadding5, BottomHeight)];
    _bottomView.backgroundColor = [UIColor colorWithHex:0xededed];
    _bottomView.layer.cornerRadius = 5;
    [self addSubview:_bottomView];
    _helpButton = [[UIButton alloc] initWithFrame:CGRectMake(kPadding10, kPadding25, CGWidth(_bottomView.frame) - 2 * kPadding10, buttonHeight)];
    [self setCommonButton:_helpButton WithTitle:@"求助上传" AndBackgroundColor:[UIColor colorWithHex:0x74c3ff]];
    [_helpButton addTarget:self action:@selector(clickSeekHelpButton:) forControlEvents:UIControlEventTouchUpInside];
    _workButton = [[UIButton alloc] initWithFrame:CGRectMake(CGOriginX(_helpButton.frame), CGRectGetMaxY(_helpButton.frame) + kPadding15, CGRectGetWidth(_helpButton.frame), buttonHeight)];
    [self setCommonButton:_workButton WithTitle:@"作品上传" AndBackgroundColor:[UIColor colorWithHex:0x74c3ff]];
    [_workButton addTarget:self action:@selector(clickUploadWorkButton:) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(CGOriginX(_helpButton.frame), CGRectGetMaxY(_workButton.frame) + kPadding15, CGRectGetWidth(_helpButton.frame), buttonHeight)];
    [self setCommonButton:_cancelButton WithTitle:@"取消" AndBackgroundColor:[UIColor colorWithHex:0xb5c0c8]];
    [_cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setCommonButton:(UIButton *)button WithTitle:(NSString *)title AndBackgroundColor:(UIColor *)color {
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 45 / 2;
    [_bottomView addSubview:button];
}

- (void)clickSeekHelpButton:(UIButton *)sender {
    [self removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(dealWithCommand:)]) {
        [_delegate dealWithCommand:@"help"];
    }
}

- (void)clickUploadWorkButton:(UIButton *)sender {
    [self removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(dealWithCommand:)]) {
        [_delegate dealWithCommand:@"work"];
    }}

- (void)clickCancelButton:(UIButton *)sender {
    [self removeFromSuperview];
}


@end
