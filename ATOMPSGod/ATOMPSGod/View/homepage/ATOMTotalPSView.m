//
//  ATOMTotalPSView.m
//  ATOMPSGod
//
//  Created by atom on 15/4/30.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMTotalPSView.h"

@interface ATOMTotalPSView ()

@property (nonatomic, strong) NSDictionary *attributeDict;

@end

@implementation ATOMTotalPSView



- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _number = @"*人";
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (NSDictionary *)attributeDict {
    if (!_attributeDict) {
        _attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Light" size:12], NSFontAttributeName, [UIColor colorWithHex:0x000000 andAlpha:0.8], NSForegroundColorAttributeName, nil];
    }
    return _attributeDict;
}

- (void)setNumber:(NSString *)number {
    _number = [NSString stringWithFormat:@"%@人", number];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat numberWidth = [[[NSAttributedString alloc] initWithString:_number attributes:_attributeDict] size].width;
    
    [_number drawInRect:CGRectMake(0, (CGRectGetHeight(rect)-kFont14)/2, numberWidth, kFont14) withAttributes:self.attributeDict];
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(numberWidth+kPadding5, (CGRectGetHeight(rect)-6)/2, 6, 6)];
    
    [[UIColor colorWithHex:0xacb8c1] set];
    [circlePath fill];
    
    [@"P过" drawInRect:CGRectMake(numberWidth+kPadding5+6+kPadding5,(CGRectGetHeight(rect)-kFont14)/2, kFont14 * 2, kFont14) withAttributes:self.attributeDict];
}
































@end
