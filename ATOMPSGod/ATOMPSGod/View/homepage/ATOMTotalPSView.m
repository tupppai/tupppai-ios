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
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (NSDictionary *)attributeDict {
    if (!_attributeDict) {
        _attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont14], NSFontAttributeName, [UIColor colorWithHex:0x666666], NSForegroundColorAttributeName, nil];
    }
    return _attributeDict;
}

- (void)setNumber:(NSString *)number {
    _number = [NSString stringWithFormat:@"%@人", number];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [_number drawInRect:CGRectMake(0, 0, _number.length * kFont14, kFont14) withAttributes:self.attributeDict];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_number.length * kFont14, 5, 6, 6)];
    [[UIColor colorWithHex:0xacb8c1] set];
    [circlePath fill];
    NSString *str = @"P过";
    [str drawInRect:CGRectMake(CGWidth(rect) - kFont14 * 2, 0, kFont14 * 2, kFont14) withAttributes:self.attributeDict];
}
































@end
