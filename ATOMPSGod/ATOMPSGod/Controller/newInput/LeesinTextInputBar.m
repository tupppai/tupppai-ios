//
//  PIETextInputbar.m
//  newInput
//
//  Created by chenpeiwei on 1/4/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import "LeesinTextInputBar.h"
#import "LeesinBottomBar.h"
#import "Masonry.h"

@interface LeesinTextInputBar ()

@property (nonatomic, strong) MASConstraint *leftButton1WC;
@property (nonatomic, strong) MASConstraint *leftButton1HC;
@property (nonatomic, strong) MASConstraint *leftButton1MarginWC;
@property (nonatomic, strong) MASConstraint *leftButton1bottomMarginWC;

@property (nonatomic, strong) MASConstraint *leftButton2WC;
@property (nonatomic, strong) MASConstraint *leftButton2HC;
@property (nonatomic, strong) MASConstraint *leftButton2MarginWC;
@property (nonatomic, strong) MASConstraint *leftButton2bottomMarginWC;

@property (nonatomic, strong) MASConstraint *rightButtonWC;
@property (nonatomic, strong) MASConstraint *rightButtonMarginWC;
@property (nonatomic, strong) MASConstraint *rightButtonBottomMarginWC;


@property (nonatomic, strong) Class textViewClass;

@end


@implementation LeesinTextInputBar

- (instancetype)initWithTextViewClass:(Class)textViewClass
{
    if (self = [super init]) {
        self.textViewClass = textViewClass;
        [self pie_commonInit];
    }
    return self;
}

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
    self.backgroundColor = [UIColor colorWithHex:0xf2f2f2 andAlpha:1.0];
    self.contentInset = UIEdgeInsetsMake(8.0, 12.0, 8.0, 5.0);
    self.buttonType = LeesinTextInputBarButtonTypeNone;
    _lastButtonType = LeesinTextInputBarButtonTypeNone;
    self.textView.placeholder = @"作品描述";
    [self addSubview:self.leftButton1];
    [self addSubview:self.leftButton2];
    [self addSubview:self.rightButton];
    [self addSubview:self.textView];
    [self pie_setupViewConstraints];
    [self pie_updateConstraintConstants];

}



- (void)pie_setupViewConstraints {
    
    [self.leftButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        self.leftButton1WC = make.width.equalTo(@0).with.priorityLow();
        self.leftButton1HC = make.height.equalTo(@0).with.priorityHigh();
        self.leftButton1MarginWC = make.leading.equalTo(self).with.priorityHigh();
        self.leftButton1bottomMarginWC = make.bottom.equalTo(self).with.priorityHigh();
    }];
    
    [self.leftButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        self.leftButton2WC = make.width.equalTo(@0).with.priorityHigh();
        self.leftButton2HC = make.height.equalTo(@0).with.priorityHigh();
        self.leftButton2MarginWC = make.leading.equalTo(self.leftButton1.mas_trailing).with.priorityHigh();
        self.leftButton2bottomMarginWC = make.bottom.equalTo(self).with.priorityHigh();
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        self.rightButtonWC = make.width.equalTo(@0).with.priorityHigh();
        self.rightButtonMarginWC = make.trailing.equalTo(self);
        self.rightButtonBottomMarginWC =  make.bottom.equalTo(self);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(self.contentInset.top);
        make.bottom.equalTo(self).with.offset(-self.contentInset.bottom).with.priorityHigh();
        make.leading.equalTo(self.leftButton2.mas_trailing).with.offset(13);
        make.trailing.equalTo(self.rightButton.mas_leading).with.offset(-10);
    }];

}

- (void) pie_updateConstraintConstants {
    
    CGSize leftButton1Size = [self.leftButton1 imageForState:self.leftButton1.state].size;
    CGSize leftButton2Size = [self.leftButton2 imageForState:self.leftButton2.state].size;
    if (leftButton1Size.width > 0) {
        [self.leftButton1HC setOffset: leftButton1Size.height ];
        [self.leftButton1bottomMarginWC setOffset: - roundf((self.intrinsicContentSize.height - leftButton1Size.height) / 2.0)];
    }
    [self.leftButton1WC setOffset: leftButton1Size.width];
    [self.leftButton1MarginWC setOffset: (leftButton1Size.width > 0) ? self.contentInset.left : 0.0];

    if (leftButton2Size.width > 0) {
        [self.leftButton2HC setOffset: roundf(leftButton2Size.height)];
        [self.leftButton2bottomMarginWC setOffset: - roundf((self.intrinsicContentSize.height - leftButton2Size.height) / 2.0)];
    }
    [self.leftButton2WC setOffset: roundf(leftButton2Size.width)];
    [self.leftButton2MarginWC setOffset: (leftButton2Size.width > 0) ? 18 : 0.0];
    
    [self.rightButtonWC setOffset: [self pie_appropriateRightButtonWidth]];
    [self.rightButtonMarginWC setOffset:-[self pie_appropriateRightButtonMargin]];
    
    
    //without this line of code rightButton's height stays zero
    [self.rightButton sizeToFit];
    
    CGFloat rightVerticalMargin = (self.intrinsicContentSize.height - CGRectGetHeight(self.rightButton.frame)) / 2.0;
    [self.rightButtonBottomMarginWC setOffset: - rightVerticalMargin ];

}

- (void)pie_hideLeftButton1 {
    [self.leftButton1MarginWC setOffset:0];
    [self.leftButton1WC setOffset:0];
    [self.leftButton1bottomMarginWC setOffset:0];
    [self.leftButton1HC setOffset:0];
    [self.leftButton2MarginWC setOffset:0];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, [self minimumInputbarHeight]);
}

- (CGFloat)pie_appropriateRightButtonWidth
{
//    if (self.autoHideRightButton) {
//        if (self.textView.text.length == 0) {
//            return 0.0;
//        }
//    }
    
    NSString *title = [self.rightButton titleForState:UIControlStateNormal];
    
    CGSize rightButtonSize;
    
    if ([title length] == 0 && self.rightButton.imageView.image) {
        rightButtonSize = self.rightButton.imageView.image.size;
    }
    else {
        rightButtonSize = [title sizeWithAttributes:@{NSFontAttributeName: self.rightButton.titleLabel.font}];
    }
    
    return rightButtonSize.width + self.contentInset.right;
}

- (CGFloat)pie_appropriateRightButtonMargin
{
//    if (self.autoHideRightButton) {
//        if (self.textView.text.length == 0) {
//            return 0.0;
//        }
//    }
    return self.contentInset.right;
}

- (CGFloat)minimumInputbarHeight
{
    CGFloat minimumTextViewHeight = self.textView.intrinsicContentSize.height;
    minimumTextViewHeight += self.contentInset.top + self.contentInset.bottom;
    
    return minimumTextViewHeight;
}

- (CGFloat)appropriateHeight
{
    CGFloat height = 0.0;
    CGFloat minimumHeight = [self minimumInputbarHeight];
    
    if (self.textView.numberOfLines == 1) {
        height = minimumHeight;
    }
    else if (self.textView.numberOfLines < self.textView.maxNumberOfLines) {
        height = [self pie_inputBarHeightForLines:self.textView.numberOfLines];
    }
    else {
        height = [self pie_inputBarHeightForLines:self.textView.maxNumberOfLines];
    }
    
    if (height < minimumHeight) {
        height = minimumHeight;
    }
    
 
    return roundf(height);
}

- (CGFloat)pie_inputBarHeightForLines:(NSUInteger)numberOfLines
{
    CGFloat height = self.textView.intrinsicContentSize.height;
    height -= self.textView.font.lineHeight;
    height += roundf(self.textView.font.lineHeight*numberOfLines);
    height += self.contentInset.top + self.contentInset.bottom;
    
    return height;
}




-(UIButton *)leftButton1 {
    if (!_leftButton1) {
        _leftButton1 = [UIButton buttonWithType:UIButtonTypeSystem];
        _leftButton1.titleLabel.font = [UIFont systemFontOfSize:15.0];
//        _leftButton1.backgroundColor = [UIColor lightGrayColor];
//        _leftButton1.backgroundColor = [UIColor clearColor];
        _leftButton1.tintColor = [UIColor clearColor];
        
        [_leftButton1 setImage:[[UIImage imageNamed:@"leesin_inputbar_button1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal];
        [_leftButton1 setImage:[[UIImage imageNamed:@"leesin_inputbar_button1_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateHighlighted];
        [_leftButton1 setImage:[[UIImage imageNamed:@"leesin_inputbar_button1_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateSelected];

    }
    return _leftButton1;
}
-(UIButton *)leftButton2 {
    if (!_leftButton2) {
        _leftButton2 = [UIButton buttonWithType:UIButtonTypeSystem];
        _leftButton2.titleLabel.font = [UIFont systemFontOfSize:15.0];
        _leftButton2.tintColor = [UIColor clearColor];
        [_leftButton2 setImage:[[UIImage imageNamed:@"leesin_inputbar_button2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_leftButton2 setImage:[[UIImage imageNamed:@"leesin_inputbar_button2_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
        [_leftButton2 setImage:[[UIImage imageNamed:@"leesin_inputbar_button2_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];

    }
    return _leftButton2;
}
-(UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _rightButton.titleLabel.font = [UIFont mediumTupaiFontOfSize:14.0];
        [_rightButton setTitleColor:[UIColor colorWithHex:0x000000 andAlpha:1.0] forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor colorWithHex:0x000000 andAlpha:0.5] forState:UIControlStateHighlighted];
        [_rightButton setTitleColor:[UIColor colorWithHex:0x000000 andAlpha:0.3] forState:UIControlStateDisabled];
        [_rightButton setTitle:@"发布" forState:UIControlStateNormal];
    }
    return _rightButton;
}

- (LeesinTextView *)textView
{
    if (!_textView) {
        Class class = self.textViewClass ? : [LeesinTextView class];
        
        _textView = [[class alloc] init];
        _textView.font = [UIFont lightTupaiFontOfSize:14.0];
        _textView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        _textView.keyboardType = UIKeyboardTypeDefault;
        _textView.returnKeyType = UIReturnKeyDefault;
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, -1.0, 0.0, 1.0);
        _textView.textContainerInset = UIEdgeInsetsMake(8.0, 4.0, 8.0, 0.0);
//        _textView.layer.cornerRadius = 5.0;
//        _textView.layer.borderWidth = 0.5;
        _textView.layer.borderColor =  [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    }
    return _textView;
}

-(void)setButtonType:(LeesinTextInputBarButtonType)buttonType {
    if (_buttonType == buttonType) {
        return;
    }
    _lastButtonType = _buttonType;
    _buttonType = buttonType;
    if (buttonType == LeesinTextInputBarButtonTypeMission) {
        self.leftButton1.selected = YES;
        self.leftButton2.selected = NO;
    } else if (buttonType == LeesinTextInputBarButtonTypePHAsset) {
        self.leftButton1.selected = NO;
        self.leftButton2.selected = YES;
    } else if (buttonType == LeesinTextInputBarButtonTypeNone) {
        self.leftButton1.selected = NO;
        self.leftButton2.selected = NO;
    }
    
}

-(void)setType:(LeesinTextInputBarType)type {
    _type = type;
    if (type == LeesinTextInputBarTypeAsk) {
        [self pie_hideLeftButton1];
        self.textView.placeholder = @"求p描述";
    } else if (type == LeesinTextInputBarTypeReply) {
        self.textView.placeholder = @"作品描述";
    }   else if (type == LeesinTextInputBarTypeReplyNoMissionSelection) {
        [self pie_hideLeftButton1];
        self.textView.placeholder = @"作品描述";
    }
}

@end
