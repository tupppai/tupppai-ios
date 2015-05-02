//
//  ATOMPraiseButton.m
//  ATOMPSGod
//
//  Created by atom on 15/4/30.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMPraiseButton.h"

@interface ATOMPraiseButton ()

@property (nonatomic, strong) NSDictionary *attributeDict;
@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, assign) CGFloat extralWidth;

@end

@implementation ATOMPraiseButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _extralWidth = 14 + kPadding5 * 2 + 2;
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

- (void)setPraiseNumber:(NSString *)praiseNumber {
    _praiseNumber = praiseNumber;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
    super.selected = selected;
    if (self.selected) {
        _currentColor = [UIColor colorWithHex:0xfe8282];
    } else {
        _currentColor = [UIColor colorWithHex:0xb2b2b2];
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor whiteColor] set];
    [rectPath fill];
    if (self.selected) {
        [[UIImage imageNamed:@"icon_like_pressed"] drawInRect:CGRectMake(0, 0, 14, 13)];
    } else {
        [[UIImage imageNamed:@"icon_like_normal"] drawInRect:CGRectMake(0, 0, 14, 13)];
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(14 + kPadding5, 5.5, 2, 2)];
    [_currentColor set];
    [path fill];
    CGRect praiseRect = CGRectMake(_extralWidth, 0, CGWidth(rect) - _extralWidth, CGHeight(rect));
    NSLog(@"%@", NSStringFromCGRect(praiseRect));
    [_praiseNumber drawInRect:praiseRect withAttributes:self.attributeDict];
}























@end
