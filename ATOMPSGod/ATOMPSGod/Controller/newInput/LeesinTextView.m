//
//  PIETextView.m
//  newInput
//
//  Created by chenpeiwei on 1/4/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import "LeesinTextView.h"
@interface LeesinTextView()

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation LeesinTextView
#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    if (self = [super initWithFrame:frame textContainer:textContainer]) {
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
    self.dataDetectorTypes = UIDataDetectorTypeNone;
    self.maxNumberOfLines = 6;
    [self pie_registerNotifications];
}


- (CGSize)intrinsicContentSize
{
    CGFloat height = self.font.lineHeight;
    height += self.textContainerInset.top + self.textContainerInset.bottom;
    
    return CGSizeMake(UIViewNoIntrinsicMetric, height);
}


-(void)layoutSubviews {
    [super layoutSubviews];
    self.placeholderLabel.hidden = [self pie_shouldHidePlaceholder];
    
    if (!self.placeholderLabel.hidden) {
        
        [UIView performWithoutAnimation:^{
            self.placeholderLabel.frame = [self pie_placeholderRectThatFits:self.bounds];
            [self sendSubviewToBack:self.placeholderLabel];
        }];
    }

}


- (BOOL)pie_shouldHidePlaceholder
{
    if (self.placeholder.length == 0 || self.text.length > 0) {
        return YES;
    }
    return NO;
}


- (CGRect)pie_placeholderRectThatFits:(CGRect)bounds
{
    CGFloat padding = self.textContainer.lineFragmentPadding;
    
    CGRect rect = CGRectZero;
    rect.size.height = [self.placeholderLabel sizeThatFits:bounds.size].height;
    rect.size.width = self.textContainer.size.width - padding*2.0;
    rect.origin = UIEdgeInsetsInsetRect(bounds, self.textContainerInset).origin;
    rect.origin.x += padding;
    
    return rect;
}


- (void)pie_didChangeText:(NSNotification *)notification
{
    if (![notification.object isEqual:self]) {
        return;
    }
    
    if (self.placeholderLabel.hidden != [self pie_shouldHidePlaceholder]) {
        [self setNeedsLayout];
    }
}
#pragma mark - Setters

- (void)setPlaceholder:(NSString *)placeholder
{
    self.placeholderLabel.text = placeholder;
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)color
{
    self.placeholderLabel.textColor = color;
}

#pragma mark - Getters

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        _placeholderLabel = [UILabel new];
        _placeholderLabel.clipsToBounds = NO;
        _placeholderLabel.autoresizesSubviews = NO;
        _placeholderLabel.numberOfLines = 1;
        _placeholderLabel.font = self.font;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.hidden = YES;
        
        [self addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

- (NSString *)placeholder
{
    return self.placeholderLabel.text;
}

- (UIColor *)placeholderColor
{
    return self.placeholderLabel.textColor;
}

- (NSUInteger)numberOfLines
{
    CGSize contentSize = self.contentSize;
    
    CGFloat contentHeight = contentSize.height;
    contentHeight -= self.textContainerInset.top + self.textContainerInset.bottom;
    
    NSUInteger lines = fabs(contentHeight/self.font.lineHeight);
    
    // This helps preventing the content's height to be larger that the bounds' height
    // Avoiding this way to have unnecessary scrolling in the text view when there is only 1 line of content
    if (lines == 1 && contentSize.height > self.bounds.size.height) {
        contentSize.height = self.bounds.size.height;
        self.contentSize = contentSize;
    }
    
    // Let's fallback to the minimum line count
    if (lines == 0) {
        lines = 1;
    }
    
    return lines;
}

- (NSUInteger)maxNumberOfLines
{
    NSUInteger numberOfLines = _maxNumberOfLines;
    
    return numberOfLines;
}


#pragma mark - NSNotificationCenter register/unregister

- (void)pie_registerNotifications
{
    [self pie_unregisterNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pie_didChangeText:) name:UITextViewTextDidChangeNotification object:nil];

}

- (void)pie_unregisterNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

@end
