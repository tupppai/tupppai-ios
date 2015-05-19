//
//  ATOMPSView.m
//  ATOMPSGod
//
//  Created by atom on 15/4/30.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMPSView.h"

@interface ATOMPSView ()

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *tipLabel;

@end

static CGFloat BottomHeight = 215;

@implementation ATOMPSView

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
    
    _downloadButton = [[UIButton alloc] initWithFrame:CGRectMake(kPadding10, kPadding25, CGWidth(_bottomView.frame) - 2 * kPadding10, buttonHeight)];
    [self setCommonButton:_downloadButton WithTitle:@"下载素材" AndBackgroundColor:[UIColor colorWithHex:0x74c3ff]];
    [_downloadButton addTarget:self action:@selector(clickDownloadButton:) forControlEvents:UIControlEventTouchUpInside];
    _uploadButton = [[UIButton alloc] initWithFrame:CGRectMake(CGOriginX(_downloadButton.frame), CGRectGetMaxY(_downloadButton.frame) + kPadding15, CGRectGetWidth(_downloadButton.frame), buttonHeight)];
    [self setCommonButton:_uploadButton WithTitle:@"上传作品" AndBackgroundColor:[UIColor colorWithHex:0x74c3ff]];
    [_uploadButton addTarget:self action:@selector(clickUploadButton:) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(CGOriginX(_downloadButton.frame), CGRectGetMaxY(_uploadButton.frame) + kPadding15, CGRectGetWidth(_downloadButton.frame), buttonHeight)];
    [self setCommonButton:_cancelButton WithTitle:@"取消" AndBackgroundColor:[UIColor colorWithHex:0xb5c0c8]];
    [_cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, SCREEN_HEIGHT / 4, CGWidth(self.frame) - 43 * 2, 60)];
    _tipLabel.numberOfLines = 0;
    _tipLabel.textColor = [UIColor whiteColor];
    _tipLabel.text = @"亲爱的大神，下载素材后可以使用以下app处理哦";
    [self addSubview:_tipLabel];
    
    CGFloat labelWidth = kShareButtonWidth + kPadding10 * 2;
    CGFloat labelHeight = 30;
    CGFloat buttonInterval = (SCREEN_WIDTH - 3 * kShareButtonWidth) / 4;
    CGFloat originY = CGRectGetMaxY(_tipLabel.frame) + kPadding25;
    _btn1 = [[UIButton alloc] initWithFrame:CGRectMake(buttonInterval, originY, kShareButtonWidth, kShareButtonWidth)];
    _btn1.backgroundColor = [UIColor whiteColor];
    [self addSubview:_btn1];
    _label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGOriginX(_btn1.frame) - kPadding10, CGRectGetMaxY(_btn1.frame), labelWidth, labelHeight)];
    _label1.textColor = [UIColor whiteColor];
    _label1.textAlignment = NSTextAlignmentCenter;
    _label1.text = @"美图秀秀";
    [self addSubview:_label1];
    
    _btn2 = [[UIButton alloc] initWithFrame:CGRectMake(buttonInterval + CGRectGetMaxX(_btn1.frame), originY, kShareButtonWidth, kShareButtonWidth)];
    _btn2.backgroundColor = [UIColor whiteColor];
    [self addSubview:_btn2];
    _label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGOriginX(_btn2.frame) - kPadding10, CGRectGetMaxY(_btn2.frame), labelWidth, labelHeight)];
    _label2.textColor = [UIColor whiteColor];
    _label2.textAlignment = NSTextAlignmentCenter;
    _label2.text = @"美图秀秀";
    [self addSubview:_label2];
    
    _btn3 = [[UIButton alloc] initWithFrame:CGRectMake(buttonInterval + CGRectGetMaxX(_btn2.frame), originY, kShareButtonWidth, kShareButtonWidth)];
    _btn3.backgroundColor = [UIColor whiteColor];
    [self addSubview:_btn3];
    _label3 = [[UILabel alloc] initWithFrame:CGRectMake(CGOriginX(_btn3.frame) - kPadding10, CGRectGetMaxY(_btn3.frame), labelWidth, labelHeight)];
    _label3.textColor = [UIColor whiteColor];
    _label3.textAlignment = NSTextAlignmentCenter;
    _label3.text = @"美图秀秀";
    [self addSubview:_label3];
}

- (void)setCommonButton:(UIButton *)button WithTitle:(NSString *)title AndBackgroundColor:(UIColor *)color {
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 45 / 2;
    [_bottomView addSubview:button];
}

- (void)clickDownloadButton:(UIButton *)sender {
    [self removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(dealImageWithCommand:)]) {
        [_delegate dealImageWithCommand:@"download"];
    }
}

- (void)clickUploadButton:(UIButton *)sender {
    [self removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(dealImageWithCommand:)]) {
        [_delegate dealImageWithCommand:@"upload"];
    }}

- (void)clickCancelButton:(UIButton *)sender {
    [self removeFromSuperview];
}

































@end
