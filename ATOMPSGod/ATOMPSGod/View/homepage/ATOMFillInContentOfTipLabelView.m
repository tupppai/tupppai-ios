//
//  ATOMFillInContentOfTipLabelView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/8.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMFillInContentOfTipLabelView.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface ATOMFillInContentOfTipLabelView ()

@property (nonatomic, strong) UIView * topView;

@end

@implementation ATOMFillInContentOfTipLabelView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    self.backgroundColor = [UIColor colorWithHex:0xffffff andAlpha:0.7];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_topView];
    _topView.layer.borderWidth = 1;
    _topView.layer.borderColor = [[UIColor colorWithHex:0x000000 andAlpha:0.2] CGColor];
    
    _showNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding15, kPadding10, kUserNameLabelWidth, kFont10)];
    _showNumberLabel.font = [UIFont systemFontOfSize:kFont10];
    _showNumberLabel.textColor = [UIColor colorWithHex:0x7fc7ff];
    _showNumberLabel.text = @"0/18";
    [_topView addSubview:_showNumberLabel];
    
    _tipLabelContentTextField = [UITextField new];
    NSDictionary *placeholderDict = [NSDictionary dictionaryWithObjectsAndKeys:NSForegroundColorAttributeName, [UIColor colorWithHex:0xededed], nil];
    _tipLabelContentTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"在此处输入你要的效果" attributes:placeholderDict];
//    _tipLabelContentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_topView addSubview:_tipLabelContentTextField];
    _tipLabelContentTextField.returnKeyType = UIReturnKeySend;
    _tipLabelContentTextField.frame = CGRectMake(kPadding15, CGRectGetMaxY(_showNumberLabel.frame) + kPadding10, CGWidth(_topView.frame) - 2 * kPadding15 - kPadding30 - kPadding10, kFont14);
    _tipLabelContentTextField.font = [UIFont systemFontOfSize:kFont14];
    
    _sendTipLabelTextButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kPadding15 - kPadding30, (60 - kPadding30) / 2, kPadding30, kPadding30)];
    _sendTipLabelTextButton.backgroundColor = [UIColor colorWithHex:0xfe8282];
    _sendTipLabelTextButton.layer.cornerRadius = kPadding30 / 2;
    [_sendTipLabelTextButton setTitle:@"添加" forState:UIControlStateNormal];
    _sendTipLabelTextButton.titleLabel.font = [UIFont boldSystemFontOfSize:10.f];
    [_sendTipLabelTextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_topView addSubview:_sendTipLabelTextButton];

    _topWarnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
    _topWarnLabel.backgroundColor = [UIColor colorWithHex:0xe86a51 andAlpha:0.9];
    _topWarnLabel.text = @"标签内容不能为空";
    _topWarnLabel.textAlignment = NSTextAlignmentCenter;
    _topWarnLabel.textColor = [UIColor whiteColor];
}




























@end
