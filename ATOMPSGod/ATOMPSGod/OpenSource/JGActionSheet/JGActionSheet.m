//
//  JGActionSheet.m
//  JGActionSheet
//
//  Created by Jonas Gessner on 25.07.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import "JGActionSheet.h"
#import <QuartzCore/QuartzCore.h>

#if !__has_feature(objc_arc)
#error "JGActionSheet requires ARC!"
#endif

#pragma mark - Defines

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 838.00
#endif

#ifndef __IPHONE_8_0
#define __IPHONE_8_0 80000
#endif

#ifndef kBaseSDKiOS8
#define kBaseSDKiOS8 (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0)
#endif

#ifndef iOS8
#define iOS8 ([UIVisualEffectView class] != Nil)
#endif

#ifndef iOS7
#define iOS7 (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0)
#endif

#ifndef rgba
#define rgba(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#endif

#ifndef rgb
#define rgb(r, g, b) rgba(r, g, b, 1.0f)
#endif

#ifndef iPad
#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#endif

#define kHostsCornerRadius 6.0f

#define kHorizontalSpacing 4.0f
#define kButtonYSpacing 5.0f

#define kArrowBaseWidth 20.0f
#define kArrowHeight 10.0f

#define kShadowRadius 4.0f
#define kShadowOpacity 0.2f

#define kFixedWidth 320.0f
#define kFixedWidthContinuous 300.0f

#define kAnimationDurationForSectionCount(count) MAX(0.22f, MIN(count*0.12f, 0.45f))

#pragma mark - Helpers

@interface JGButton : UIButton

@property (nonatomic, assign) NSUInteger row;

@end

@implementation JGButton

@end


static BOOL disableCustomEasing = NO;

@interface JGActionSheetLayer : CAShapeLayer

@end

@implementation JGActionSheetLayer

- (void)addAnimation:(CAAnimation *)anim forKey:(NSString *)key {
    if (!disableCustomEasing && [anim isKindOfClass:[CABasicAnimation class]]) {
        CAMediaTimingFunction *func = [CAMediaTimingFunction functionWithControlPoints:0.215f: 0.61f: 0.355f: 1.0f];
        
        anim.timingFunction = func;
    }
    
    [super addAnimation:anim forKey:key];
}

@end

@interface JGActionSheetView : UIView

@end

@implementation JGActionSheetView

+ (Class)layerClass {
    return [JGActionSheetLayer class];
}

@end

#pragma mark - JGActionSheetSection

@interface JGActionSheetSection ()

@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, copy) void (^buttonPressedBlock)(NSIndexPath *indexPath);

- (void)setUpForContinuous:(BOOL)continuous;

@end

@implementation JGActionSheetSection

#pragma mark Initializers

+ (instancetype)cancelSection {
    return [self sectionWithTitle:nil message:nil buttonTitles:@[NSLocalizedString(@"Cancel",)] buttonStyle:JGActionSheetButtonStyleCancel];
}

+ (instancetype)sectionWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonStyle:(JGActionSheetButtonStyle)buttonStyle {
    return [[self alloc] initWithTitle:title message:message buttonTitles:buttonTitles buttonStyle:buttonStyle];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonStyle:(JGActionSheetButtonStyle)buttonStyle {
    self = [super init];
    
    if (self) {
        if (title) {
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:14.0f];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.numberOfLines = 1;
            
            titleLabel.text = title;
            
            _titleLabel = titleLabel;
            
            [self addSubview:_titleLabel];
        }
        
        if (message) {
            UILabel *messageLabel = [[UILabel alloc] init];
            messageLabel.backgroundColor = [UIColor clearColor];
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.font = [UIFont systemFontOfSize:12.0f];
            messageLabel.textColor = [UIColor blackColor];
            messageLabel.numberOfLines = 0;
            
            messageLabel.text = message;
            
            _messageLabel = messageLabel;
            
            [self addSubview:_messageLabel];
        }
        
        if (buttonTitles.count) {
            NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:buttonTitles.count];
            
            NSInteger index = 0;
            
            for (NSString *str in buttonTitles) {
                JGButton *b = [self makeButtonWithTitle:str style:buttonStyle];
                b.row = (NSUInteger)index;
                
                [self addSubview:b];
                
                [buttons addObject:b];
                
                index++;
            }
            
            _buttons = buttons.copy;
        }
    }
    
    return self;
}

+ (instancetype)sectionWithTitle:(NSString *)title message:(NSString *)message contentView:(UIView *)contentView {
    return [[self alloc] initWithTitle:title message:message contentView:contentView];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message contentView:(UIView *)contentView {
    self = [super init];
    
    if (self) {
        if (title) {
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.numberOfLines = 1;
            
            titleLabel.text = title;
            
            _titleLabel = titleLabel;
            
            [self addSubview:_titleLabel];
        }
        
        if (message) {
            UILabel *messageLabel = [[UILabel alloc] init];
            messageLabel.backgroundColor = [UIColor clearColor];
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.font = [UIFont systemFontOfSize:12.0f];
            messageLabel.textColor = [UIColor blackColor];
            messageLabel.numberOfLines = 0;
            
            messageLabel.text = message;
            
            _messageLabel = messageLabel;
            
            [self addSubview:_messageLabel];
        }
        
        _contentView = contentView;
        
        [self addSubview:self.contentView];
    }
    
    return self;
}

#pragma mark UI

- (void)setUpForContinuous:(BOOL)continuous {
    if (continuous) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 0.0f;
        self.layer.shadowOpacity = 0.0f;
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.cornerRadius = kHostsCornerRadius;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowRadius = kShadowRadius;
        self.layer.shadowOpacity = kShadowOpacity;
        
    }
}

- (void)setButtonStyle:(JGActionSheetButtonStyle)buttonStyle forButtonAtIndex:(NSUInteger)index {
    if (index < self.buttons.count) {
        UIButton *button = self.buttons[index];
        
        [self setButtonStyle:buttonStyle forButton:button];
    }
    else {
        NSLog(@"ERROR: Index out of bounds");
        return;
    }
}

- (UIImage *)pixelImageWithColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions((CGSize){1.0f, 1.0f}, YES, 0.0f);
    
    [color setFill];
    
    [[UIBezierPath bezierPathWithRect:(CGRect){CGPointZero, {1.0f, 1.0f}}] fill];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [img resizableImageWithCapInsets:UIEdgeInsetsZero];
}

- (void)setButtonStyle:(JGActionSheetButtonStyle)buttonStyle forButton:(UIButton *)button {
    UIColor *backgroundColor, *borderColor, *titleColor = nil;
    UIFont *font = nil;
    
    if (buttonStyle == JGActionSheetButtonStyleDefault) {
        font = [UIFont boldSystemFontOfSize:17.0];
        titleColor = [UIColor darkGrayColor];
        backgroundColor = [UIColor colorWithHex:0xFEF07B];
        borderColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    }
    else if (buttonStyle == JGActionSheetButtonStyleCancel) {
        font = [UIFont boldSystemFontOfSize:17.0];
        titleColor = [UIColor darkGrayColor];
        backgroundColor = [UIColor colorWithHex:0xb5c0c8];
        borderColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    }
    else if (buttonStyle == JGActionSheetButtonStyleRed) {
        font = [UIFont systemFontOfSize:15.0f];
        titleColor = [UIColor whiteColor];
        
        backgroundColor = rgb(231.0f, 76.0f, 60.0f);
        borderColor = rgb(192.0f, 57.0f, 43.0f);
    }
    else if (buttonStyle == JGActionSheetButtonStyleGreen) {
        font = [UIFont systemFontOfSize:15.0f];
        titleColor = [UIColor whiteColor];
        
        backgroundColor = rgb(46.0f, 204.0f, 113.0f);
        borderColor = rgb(39.0f, 174.0f, 96.0f);
    }
    else if (buttonStyle == JGActionSheetButtonStyleBlue) {
        font = [UIFont systemFontOfSize:15.0f];
        titleColor = [UIColor whiteColor];
        
        backgroundColor = rgb(52.0f, 152.0f, 219.0f);
        borderColor = rgb(41.0f, 128.0f, 185.0f);
    }
    
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    button.titleLabel.font = font;
    [button setBackgroundImage:[self pixelImageWithColor:backgroundColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[self pixelImageWithColor:borderColor] forState:UIControlStateHighlighted];
    button.layer.cornerRadius = 45 / 2;
    button.layer.borderColor = borderColor.CGColor;
}

- (JGButton *)makeButtonWithTitle:(NSString *)title style:(JGActionSheetButtonStyle)style {
    JGButton *b = [[JGButton alloc] init];
    
    b.layer.cornerRadius = 2.0f;
    b.layer.masksToBounds = YES;
    b.layer.borderWidth = 1.0f;
    
    [b setTitle:title forState:UIControlStateNormal];
    
    [b addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setButtonStyle:style forButton:b];
    
    return b;
}

- (void)buttonPressed:(JGButton *)button {
    if (self.buttonPressedBlock) {
        self.buttonPressedBlock([NSIndexPath indexPathForRow:(NSInteger)button.row inSection:(NSInteger)self.index]);
    }
}

- (CGRect)layoutForWidth:(CGFloat)width {
    CGFloat buttonHeight = 50.0f;
    CGFloat spacing = kButtonYSpacing;
    
    CGFloat height = 0.0f;
    CGFloat whiteGapHeight = 15.0;
    UIView* whiteGapView = [UIView new];
    whiteGapView.frame = (CGRect) {CGPointZero,{0,whiteGapHeight}};
    [self addSubview:whiteGapView];
    height += whiteGapHeight;
    
    if (self.titleLabel) {
        height += spacing;
        
        [self.titleLabel sizeToFit];
        height += CGRectGetHeight(self.titleLabel.frame);
        
        self.titleLabel.frame = (CGRect){{spacing, spacing}, {width-spacing*2.0f, CGRectGetHeight(self.titleLabel.frame)}};
    }
    
    if (self.messageLabel) {
        height += spacing;
        
        CGSize maxLabelSize = {width-spacing*2.0f, width};
        
        CGFloat messageLabelHeight = 0.0f;
        
        if (iOS7) {
            NSDictionary *attributes = @{NSFontAttributeName : self.messageLabel.font};
            
            messageLabelHeight = CGRectGetHeight([self.messageLabel.text boundingRectWithSize:maxLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil]);
        }
        else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            messageLabelHeight = [self.messageLabel.text sizeWithFont:self.messageLabel.font constrainedToSize:maxLabelSize lineBreakMode:self.messageLabel.lineBreakMode].height;
#pragma clang diagnostic pop
        }
        
        self.messageLabel.frame = (CGRect){{spacing, height}, {width-spacing*2.0f, messageLabelHeight}};
        
        height += messageLabelHeight;
    }
    
    for (UIButton *button in self.buttons) {
        
            height += spacing;
        
        button.frame = (CGRect){{spacing, height}, {width-spacing*2.0f, buttonHeight}};
        
        height += buttonHeight;
    }
    
    if (self.contentView) {
        height += spacing;
        
        self.contentView.frame = (CGRect){{spacing, height}, {width-spacing*2.0f, self.contentView.frame.size.height}};
        
        height += CGRectGetHeight(self.contentView.frame);
    }
    
    height += spacing;
    height += whiteGapHeight;
    self.frame = (CGRect){CGPointZero, {width, height}};
    
    //draw topLeft and TopRight cornor radius to section.
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(6.0, 6.0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    return self.frame;
}

@end

#pragma mark - JGActionSheet

@interface JGActionSheet () <UIGestureRecognizerDelegate> {
    UIScrollView *_scrollView;
    JGActionSheetView *_scrollViewHost;
    
    CGRect _finalContentFrame;
    
    UIColor *_realBGColor;
    
    BOOL _anchoredAtPoint;
    CGPoint _anchorPoint;
    JGActionSheetArrowDirection _anchoredArrowDirection;
}

@end

@implementation JGActionSheet

@dynamic visible;

#pragma mark Initializers

+ (instancetype)actionSheetWithSections:(NSArray *)sections {
    return [[self alloc] initWithSections:sections];
}

- (instancetype)initWithSections:(NSArray *)sections {
    NSAssert(sections.count > 0, @"Must at least provide 1 section");
    
    self = [super init];
    
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        tap.delegate = self;
        
        [self addGestureRecognizer:tap];
        
        _scrollViewHost = [[JGActionSheetView alloc] init];
        _scrollViewHost.backgroundColor = [UIColor clearColor];
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        [_scrollViewHost addSubview:_scrollView];
        [self addSubview:_scrollViewHost];
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        _sections = sections;
        
        NSInteger index = 0;
        
        __weak __typeof(self) weakSelf = self;
        
        void (^pressedBlock)(NSIndexPath *) = ^(NSIndexPath *indexPath) {
            [weakSelf buttonPressed:indexPath];
        };
        
        for (JGActionSheetSection *section in self.sections) {
            section.index = index;
            
            [_scrollView addSubview:section];
            
            [section setButtonPressedBlock:pressedBlock];
            
            index++;
        }
    }
    
    return self;
}

#pragma mark Overrides

+ (Class)layerClass {
    return [JGActionSheetLayer class];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    _realBGColor = backgroundColor;
}

#pragma mark Callbacks

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self hitTest:[gestureRecognizer locationInView:self] withEvent:nil] == self && self.outsidePressBlock) {
        return YES;
    }
    
    return NO;
}

- (void)tapped:(UITapGestureRecognizer *)gesture {
    if ([self hitTest:[gesture locationInView:self] withEvent:nil] == self && self.outsidePressBlock) {
        self.outsidePressBlock(self);
    }
}



- (void)buttonPressed:(NSIndexPath *)indexPath {
    if (self.buttonPressedBlock) {
        self.buttonPressedBlock(self, indexPath);
    }
    
    if ([self.delegate respondsToSelector:@selector(actionSheet:pressedButtonAtIndexPath:)]) {
        [self.delegate actionSheet:self pressedButtonAtIndexPath:indexPath];
    }
}

#pragma mark Layout

- (void)layoutSheetForFrame:(CGRect)frame fitToRect:(BOOL)fitToRect initialSetUp:(BOOL)initial continuous:(BOOL)continuous {
//    if (continuous) {
//        frame.size.width = kFixedWidthContinuous;
//    }
    
    CGFloat spacing = 2.0f*kHorizontalSpacing;
    
    CGFloat width = CGRectGetWidth(frame);
    
    if (!continuous) {
        width -= 2.0f*spacing;
    }
    
    CGFloat height = (continuous ? 0.0f : spacing);
    
    for (JGActionSheetSection *section in self.sections) {
        if (initial) {
            [section setUpForContinuous:continuous];
        }
        
        CGRect f = [section layoutForWidth:width];
        f.origin.y = height;

        if (!continuous) {
            f.origin.x = spacing;
        }
        
        section.frame = f;
        
        height += CGRectGetHeight(f);
    }
    
//    if (continuous) {
//        height -= spacing;
//    }
    
    _scrollView.contentSize = (CGSize){CGRectGetWidth(frame), height};
    
    if (!fitToRect && !continuous) {
        frame.size.height = CGRectGetHeight(_targetView.bounds)-CGRectGetMinY(frame);
    }
    
    if (height > CGRectGetHeight(frame)) {
        _scrollViewHost.frame = frame;
    }
    else {
        CGFloat finalY = 0.0f;
        
        if (fitToRect) {
            finalY = CGRectGetMaxY(frame)-height;
        }
        else if (continuous) {
            finalY = CGRectGetMinY(frame);
        }
        else {
            finalY = CGRectGetMinY(frame)+(CGRectGetHeight(frame)-height)/2.0f;
        }
        
        _scrollViewHost.frame = (CGRect){{CGRectGetMinX(frame), finalY}, _scrollView.contentSize};
    }
    
    _finalContentFrame = _scrollViewHost.frame;
    
    _scrollView.frame = _scrollViewHost.bounds;
    
    [_scrollView scrollRectToVisible:(CGRect){{0.0f, _scrollView.contentSize.height-1.0f}, {1.0f, 1.0f}} animated:NO];
}

- (void)layoutForVisible:(BOOL)visible {
    UIView *viewToModify = _scrollViewHost;
    //可见
    if (visible) {
        self.backgroundColor = _realBGColor;
        
        if (iPad) {
            viewToModify.alpha = 1.0f;
//            _arrowView.alpha = 1.0f;
        }
        else {
            viewToModify.frame = _finalContentFrame;
        }
    }
    //不可见
    else {
        super.backgroundColor = [UIColor clearColor];
        
        if (iPad) {
            viewToModify.alpha = 0.0f;
//            _arrowView.alpha = 0.0f;
        }
        else {
            viewToModify.frame = (CGRect){{viewToModify.frame.origin.x, CGRectGetHeight(_targetView.bounds)}, _scrollView.contentSize};
        }
    }
}

#pragma mark Showing

- (void)showInView:(UIView *)view animated:(BOOL)animated {
    NSAssert(!self.visible, @"Action Sheet is already visisble!");
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    _targetView = view;
    
    [self layoutSheetInitial:YES];
    
    if ([self.delegate respondsToSelector:@selector(actionSheetWillPresent:)]) {
        [self.delegate actionSheetWillPresent:self];
    }
    
    void (^completion)(void) = ^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        if ([self.delegate respondsToSelector:@selector(actionSheetDidPresent:)]) {
            [self.delegate actionSheetDidPresent:self];
        }
    };
    
    
    [self layoutForVisible:!animated];
    
    [_targetView addSubview:self];
    
    if (!animated) {
        completion();
    }
    else {
        CGFloat duration = (iPad ? 0.3f : kAnimationDurationForSectionCount(self.sections.count));
        
        [UIView animateWithDuration:duration animations:^{
            [self layoutForVisible:YES];
        } completion:^(BOOL finished) {
            completion();
        }];
    }
}

- (void)layoutSheetInitial:(BOOL)initial {
    self.frame = _targetView.bounds;
    
    _scrollViewHost.layer.cornerRadius = 0.0f;
    _scrollViewHost.layer.shadowOpacity = 0.0f;
    _scrollViewHost.backgroundColor = [UIColor clearColor];
    
    CGRect frame = self.frame;
    
    if (iPad) {
        CGFloat fixedWidth = kFixedWidth;
        
        frame.origin.x = (CGRectGetWidth(frame)-fixedWidth)/2.0f;
        
        frame.size.width = fixedWidth;
    }
    
    frame = UIEdgeInsetsInsetRect(frame, self.insets);
    
    [self layoutSheetForFrame:frame fitToRect:!iPad initialSetUp:initial continuous:NO];
}



#pragma mark Dismissal

- (void)dismissAnimated:(BOOL)animated {
    NSAssert(self.visible, @"Action Sheet requires to be visible in order to dismiss!");
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    void (^completion)(void) = ^{
//        [_arrowView removeFromSuperview];
//        _arrowView = nil;
        
        _targetView = nil;
        
        [self removeFromSuperview];
        
        _anchoredAtPoint = NO;
        _anchoredArrowDirection = 0;
        _anchorPoint = CGPointZero;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        if ([self.delegate respondsToSelector:@selector(actionSheetDidDismiss:)]) {
            [self.delegate actionSheetDidDismiss:self];
        }
    };
    
    if ([self.delegate respondsToSelector:@selector(actionSheetWillDismiss:)]) {
        [self.delegate actionSheetWillDismiss:self];
    }
    
    if (animated) {
        CGFloat duration = 0.0f;
        
        if (iPad) {
            duration = 0.3f;
        }
        else {
            duration = kAnimationDurationForSectionCount(self.sections.count);
        }
        
        [UIView animateWithDuration:duration animations:^{
            [self layoutForVisible:NO];
        } completion:^(BOOL finished) {
            completion();
        }];
    }
    else {
        [self layoutForVisible:NO];
        
        completion();
    }
}

#pragma mark Visibility

- (BOOL)isVisible {
    return (_targetView != nil);
}

@end
