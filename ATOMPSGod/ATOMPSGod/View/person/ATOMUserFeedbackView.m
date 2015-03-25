//
//  ATOMUserFeedbackView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/25.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMUserFeedbackView.h"

@interface ATOMUserFeedbackView ()

@property (nonatomic, strong) UIView *feedbackView;
@property (nonatomic, strong) UIView *contactView;
@property (nonatomic, strong) UILabel *tipLabelTitle;
@property (nonatomic, strong) UILabel *tipLabelContent;
@property (nonatomic, strong) NSDictionary *attributeDict;

@end

@implementation ATOMUserFeedbackView

static int padding15 = 15;
static int padding10 = 10;

- (instancetype)init {
    self = [super init];
    if (self) {
        _attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHex:0xc6c6c6], NSForegroundColorAttributeName, [UIFont systemFontOfSize:16.f], NSFontAttributeName, nil];
        _feedbackTextViewPlaceholder = [[NSAttributedString alloc] initWithString:@"请在这里填写你对求PS大神的建议，我们将不断改进，感谢支持" attributes:_attributeDict];
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    
    _feedbackView = [[UIView alloc] initWithFrame:CGRectMake(padding10, padding15, SCREEN_WIDTH - padding10 * 2, 136)];
    _feedbackView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_feedbackView];
    _contactView = [[UIView alloc] initWithFrame:CGRectMake(padding10, CGRectGetMaxY(_feedbackView.frame) + padding15, CGWidth(_feedbackView.frame), 34)];
    _contactView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contactView];
    
    _feedbackTextView = [[UITextView alloc] initWithFrame:CGRectMake(padding10, 0, CGWidth(_feedbackView.frame) - padding10 * 2, CGHeight(_feedbackView.frame))];
    _feedbackTextView.backgroundColor = [UIColor whiteColor];
    _feedbackTextView.attributedText = _feedbackTextViewPlaceholder;
    [_feedbackView addSubview:_feedbackTextView];
    
    _contactTextField = [[UITextField alloc] initWithFrame:CGRectMake(padding10, 0, CGWidth(_contactView.frame) - padding10 * 2, CGHeight(_contactView.frame))];
    _contactTextField.backgroundColor = [UIColor whiteColor];
    _contactTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"电话或QQ" attributes:_attributeDict];
    _contactTextField.layer.cornerRadius = 5;
    _contactTextField.layer.masksToBounds = YES;
    [_contactView addSubview:_contactTextField];
    
    _tipLabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding10 * 2, CGRectGetMaxY(_contactView.frame) + padding15, 50, 25)];
    _tipLabelTitle.text = @"小贴士";
    _tipLabelTitle.textColor = [UIColor colorWithHex:0x666666];
    _tipLabelTitle.font = [UIFont systemFontOfSize:16.f];
    [self addSubview:_tipLabelTitle];
    
    _tipLabelContent = [[UILabel alloc] initWithFrame:CGRectMake(padding10 *2, CGRectGetMaxY(_tipLabelTitle.frame), SCREEN_WIDTH - padding10 * 4, 70)];
    _tipLabelContent.numberOfLines = 0;
    _tipLabelContent.text = @"如果突然不能正常使用求PS大神，可重启求PS大神或手机试试，您还可以加入求PS大神建议反馈群：348701666";
    _tipLabelContent.textColor = [UIColor colorWithHex:0x666666];
    _tipLabelContent.font =[UIFont systemFontOfSize:16.f];
    [self addSubview:_tipLabelContent];
    
}







































@end
