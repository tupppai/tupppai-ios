//
//  ATOMBottomCommonButton.m
//  ATOMPSGod
//
//  Created by atom on 15/4/30.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBottomCommonButton.h"

@interface ATOMBottomCommonButton ()

@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, assign) CGFloat extralWidth;
@property (nonatomic, strong) NSDictionary *attributeDict;

@end

@implementation ATOMBottomCommonButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _extralWidth = 24 + kPadding5;
        self.selected = NO;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (NSDictionary *)attributeDict {
    _attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, _currentColor, NSForegroundColorAttributeName, nil];
    return _attributeDict;
}

- (void)setNumber:(NSString *)number {
    _number = number;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (!selected) {
        _currentColor = [UIColor colorWithHex:0xcdcdcd];
    } else {
        _currentColor = [UIColor colorWithHex:0xfe8282];
    }
    [self setNeedsDisplay];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor whiteColor] set];
    [rectPath fill];
    if (_selected) {
        [[UIImage imageNamed:@"btn_comment_like_pressed"] drawInRect:CGRectMake(0, 0, kBottomCommonButtonWidth, kBottomCommonButtonWidth)];
    } else {
        [_image drawInRect:CGRectMake(0, 0, kBottomCommonButtonWidth, kBottomCommonButtonWidth)];
    }
    [_number drawInRect:CGRectMake(kBottomCommonButtonWidth + kPadding5, (CGHeight(rect) - kFont10) / 2, CGWidth(rect) - _extralWidth, kFont10) withAttributes:self.attributeDict];
}






































@end
