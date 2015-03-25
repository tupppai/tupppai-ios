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

static int padding10 = 10;
static int padding3 = 3;

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
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_topView];
    _topView.layer.borderWidth = 1;
    _topView.layer.borderColor = [[UIColor colorWithHex:0xb3b3b3] CGColor];
    
    _tipLabelContentTextField = [UITextField new];
    NSDictionary *placeholderDict = [NSDictionary dictionaryWithObjectsAndKeys:NSForegroundColorAttributeName, [UIColor colorWithHex:0xededed], nil];
    _tipLabelContentTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"在此处输入你要的效果" attributes:placeholderDict];
//    _tipLabelContentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_topView addSubview:_tipLabelContentTextField];
    _tipLabelContentTextField.returnKeyType = UIReturnKeySend;
    _tipLabelContentTextField.frame = CGRectMake(padding10, padding3, CGWidth(_topView.frame) - 3 * padding10 - 34, CGHeight(_topView.frame) - 2 * padding3);
    
    _showNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, CGHeight(_tipLabelContentTextField.frame))];
    _showNumberLabel.textColor = [UIColor colorWithHex:0xededed];
    _showNumberLabel.textAlignment = NSTextAlignmentRight;
    _showNumberLabel.text = @"0/18";
    _tipLabelContentTextField.rightView = _showNumberLabel;
    _tipLabelContentTextField.rightViewMode = UITextFieldViewModeAlways;
    
    _sendTipLabelTextButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - padding10 - 34, padding3, 34, 34)];
    _sendTipLabelTextButton.backgroundColor = [UIColor colorWithHex:0xfcc64a];
    _sendTipLabelTextButton.layer.cornerRadius = 17;
    _sendTipLabelTextButton.layer.masksToBounds = YES;
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
