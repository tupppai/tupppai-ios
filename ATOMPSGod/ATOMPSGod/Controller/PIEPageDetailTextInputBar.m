//
//  PIEPageDetailTextInputBar.m
//  TUPAI
//
//  Created by chenpeiwei on 2/22/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEPageDetailTextInputBar.h"
#import "LeesinTextView.h"

@interface PIEPageDetailTextInputBar()
@property (nonatomic, strong) Class textViewClass;
@end


@implementation PIEPageDetailTextInputBar

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
    self.textView.placeholder = @"添加评论";
    [self addSubview:self.rightButton];
    [self addSubview:self.textView];
    [self pie_setupViewConstraints];
}



- (void)pie_setupViewConstraints {
    

    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(self.contentInset.top);
        make.bottom.equalTo(self).with.offset(-self.contentInset.bottom).with.priorityHigh();
        make.leading.equalTo(self).with.offset(13);
        make.trailing.equalTo(self.rightButton.mas_leading).with.offset(-10);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([self pie_appropriateRightButtonWidth])).with.priorityHigh();
        make.trailing.equalTo(self).with.offset(-[self pie_appropriateRightButtonMargin]);
        make.centerY.equalTo(self.textView);
    }];
    
    [self.rightButton sizeToFit];
    
}



- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, [self minimumInputbarHeight]);
}

- (CGFloat)pie_appropriateRightButtonWidth
{
    
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


-(UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _rightButton.titleLabel.font = [UIFont mediumTupaiFontOfSize:14.0];
        [_rightButton setTitleColor:[UIColor colorWithHex:0x000000 andAlpha:1.0] forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor colorWithHex:0x000000 andAlpha:0.5] forState:UIControlStateHighlighted];
        [_rightButton setTitleColor:[UIColor colorWithHex:0x000000 andAlpha:0.3] forState:UIControlStateDisabled];
        [_rightButton setTitle:@"发送" forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(tapRightButton:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.enabled = NO;
    }
    return _rightButton;
}

- (void)tapRightButton:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(pageDetailTextInputBar:tapRightButton:)]) {
        [_delegate pageDetailTextInputBar:self tapRightButton:sender];
    }
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
@end
