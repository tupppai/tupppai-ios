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

static int padding20 = 20;
static int padding3 = 3;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0.7;
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [self addSubview:_topView];
    _topView.layer.borderWidth = 1;
    _topView.layer.borderColor = [[UIColor colorWithHex:0xb3b3b3] CGColor];
    
    _tipLabelContentTextField = [UITextField new];
    _tipLabelContentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_topView addSubview:_tipLabelContentTextField];
    _tipLabelContentTextField.returnKeyType = UIReturnKeySend;
    
    _tipLabelContentTextField.frame = CGRectMake(padding20, padding3, CGWidth(_topView.frame) - 2 * padding20, CGHeight(_topView.frame) - 2 * padding3);
}

@end
