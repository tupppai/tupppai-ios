//
//  ATOMTipButton.m
//  ATOMPSGod
//
//  Created by atom on 15/3/6.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMTipButton.h"

@interface ATOMTipButton ()

@property (nonatomic, strong) NSDictionary *attributeDic;

@end

@implementation ATOMTipButton

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSDictionary *)attributeDic {
    if (_attributeDic == nil) {
        _attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.f], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    }
    return _attributeDic;
}

- (void)drawRect:(CGRect)rect {
    UIColor *color = [UIColor colorWithHex:0x000000 andAlpha:0.5];
    [color set];
    UIBezierPath * path = [UIBezierPath bezierPath];
    
    UIImage *tagImage = [UIImage imageNamed:@"tag_point"];
    
    CGPoint imageOriginPoint;
    CGPoint centerControlPoint;
    CGPoint topLeftControlPoint;
    CGPoint topRightControlPoint;
    CGPoint bottomRightControlPoint;
    CGPoint bottomLeftControlPoint;
    
    static int INTERVAL2 = 2;
    static int INTERVAL5 = 5;
    
    if (_tipButtonType == ATOMLeftTipType) {
        
        imageOriginPoint = CGPointMake(0, 7.5);
        [tagImage drawInRect:CGRectMake(imageOriginPoint.x, imageOriginPoint.y, 15, 15)];
        centerControlPoint = CGPointMake(16, CGRectGetMidY(rect));
        topLeftControlPoint = CGPointMake(30, 0);
        topRightControlPoint = CGPointMake(CGRectGetMaxX(rect), 0);
        bottomRightControlPoint = CGPointMake(CGRectGetMaxX(rect), CGHeight(rect));
        bottomLeftControlPoint = CGPointMake(30, CGHeight(rect));
        
        [path moveToPoint:CGPointMake(centerControlPoint.x + INTERVAL2, centerControlPoint.y - INTERVAL2)];
        [path addLineToPoint:CGPointMake(topLeftControlPoint.x - INTERVAL2, topLeftControlPoint.y + INTERVAL2)];
        //设置左上方圆角
        [path addQuadCurveToPoint:CGPointMake(topLeftControlPoint.x + INTERVAL2, topLeftControlPoint.y) controlPoint:topLeftControlPoint];
        
        [path addLineToPoint:CGPointMake(topRightControlPoint.x - INTERVAL5, topRightControlPoint.y)];
        //设置右上方圆角
        [path addQuadCurveToPoint:CGPointMake(topRightControlPoint.x, topRightControlPoint.y + INTERVAL5) controlPoint:topRightControlPoint];
        
        [path addLineToPoint:CGPointMake(bottomRightControlPoint.x, bottomRightControlPoint.y - INTERVAL5)];
        //设置右下方圆角
        [path addQuadCurveToPoint:CGPointMake(bottomRightControlPoint.x - INTERVAL5, bottomRightControlPoint.y) controlPoint:bottomRightControlPoint];
        
        [path addLineToPoint:CGPointMake(bottomLeftControlPoint.x + INTERVAL2, bottomLeftControlPoint.y)];
        //设置左下方圆角
        [path addQuadCurveToPoint:CGPointMake(bottomLeftControlPoint.x - INTERVAL2, bottomLeftControlPoint.y - INTERVAL2) controlPoint:bottomLeftControlPoint];
        
        [path addLineToPoint:CGPointMake(centerControlPoint.x + INTERVAL2, centerControlPoint.y + INTERVAL2)];
        
        //设置中心圆角
        [path addQuadCurveToPoint:CGPointMake(centerControlPoint.x + INTERVAL2, centerControlPoint.y - INTERVAL2) controlPoint:centerControlPoint];
        
        [path fill];
        
        [_buttonText drawInRect:CGRectMake(topLeftControlPoint.x, 9, CGWidth(rect) - topLeftControlPoint.y, CGHeight(rect)) withAttributes:self.attributeDic];
    } else {
        
        imageOriginPoint = CGPointMake(CGRectGetMaxX(rect) - 15, 7.5);
        [tagImage drawInRect:CGRectMake(imageOriginPoint.x, imageOriginPoint.y, 15, 15)];
        centerControlPoint = CGPointMake(CGRectGetMaxX(rect) - 16, CGRectGetMidY(rect));
        topLeftControlPoint = CGPointMake(0, 0);
        topRightControlPoint = CGPointMake(CGRectGetMaxX(rect) - 30, 0);
        bottomRightControlPoint = CGPointMake(CGRectGetMaxX(rect) - 30, CGHeight(rect));
        bottomLeftControlPoint = CGPointMake(0, CGHeight(rect));
        
        [path moveToPoint:CGPointMake(centerControlPoint.x - INTERVAL2, centerControlPoint.y - INTERVAL2)];
        [path addLineToPoint:CGPointMake(topRightControlPoint.x + INTERVAL2, topLeftControlPoint.y + INTERVAL2)];
        //设置右上方圆角
        [path addQuadCurveToPoint:CGPointMake(topRightControlPoint.x - INTERVAL2, topRightControlPoint.y) controlPoint:topRightControlPoint];
        
        [path addLineToPoint:CGPointMake(topLeftControlPoint.x + INTERVAL5, topLeftControlPoint.y)];
        //设置左上方圆角
        [path addQuadCurveToPoint:CGPointMake(topLeftControlPoint.x, topLeftControlPoint.y + INTERVAL5) controlPoint:topLeftControlPoint];
        
        [path addLineToPoint:CGPointMake(bottomLeftControlPoint.x, bottomLeftControlPoint.y - INTERVAL5)];
        //设置左下方圆角
        [path addQuadCurveToPoint:CGPointMake(bottomLeftControlPoint.x + INTERVAL5, bottomLeftControlPoint.y) controlPoint:bottomLeftControlPoint   ];
        
        [path addLineToPoint:CGPointMake(bottomRightControlPoint.x - INTERVAL2, bottomRightControlPoint.y)];
        //设置右下方圆角
        [path addQuadCurveToPoint:CGPointMake(bottomRightControlPoint.x + INTERVAL2, bottomRightControlPoint.y - INTERVAL2) controlPoint:bottomRightControlPoint];
        
        [path addLineToPoint:CGPointMake(centerControlPoint.x - INTERVAL2, centerControlPoint.y + INTERVAL2)];
        //设置中心圆角
        [path addQuadCurveToPoint:CGPointMake(centerControlPoint.x - INTERVAL2, centerControlPoint.y - INTERVAL2) controlPoint:centerControlPoint];
        
        [path fill];
        
        [_buttonText drawInRect:CGRectMake(10, 9, topRightControlPoint.x, CGHeight(rect)) withAttributes:self.attributeDic];
    }
}

- (void)setButtonText:(NSString *)buttonText {
    _buttonText = buttonText;
    [self setNeedsDisplay];
}

- (void)setTipButtonType:(ATOMTipButtonType)tipButtonType {
    _tipButtonType = tipButtonType;
    [self setNeedsDisplay];
}

- (void)constrainTipLabelToImageView {
    CGRect frame = self.frame;
    BOOL change;
    do {
        change = NO;
        if (CGOriginX(frame) < 0) {
            frame.origin.x = 0;
            change = YES;
        }
        
        if (CGOriginX(frame) + CGWidth(frame) > CGWidth(self.superview.frame)) {
            frame.origin.x = CGWidth(self.superview.frame) - CGWidth(frame);
            change = YES;
        }
        
        if (CGOriginY(frame) < 0) {
            frame.origin.y = 0;
            change = YES;
        }
        
        if (CGOriginY(frame) + CGHeight(frame) > CGHeight(self.superview.frame)) {
            frame.origin.y = CGHeight(self.superview.frame) - CGHeight(frame);
            change = YES;
        }
    } while (change);
    
    self.frame = frame;
}

- (void)changeTipLabelDirection {
    CGRect newFrame;
    ATOMTipButtonType newTipButtonType;
    if (_tipButtonType == ATOMLeftTipType) {
        newFrame = CGRectMake(CGOriginX(self.frame) - CGWidth(self.frame) + 15, CGOriginY(self.frame), CGWidth(self.frame), CGHeight(self.frame));
        newTipButtonType = ATOMRightTipType;
    } else {
        newFrame = CGRectMake(CGOriginX(self.frame) + CGWidth(self.frame) - 15, CGOriginY(self.frame), CGWidth(self.frame), CGHeight(self.frame));
        newTipButtonType = ATOMLeftTipType;
    }
    if ([self isOverBounds:newFrame]) {
        
    } else {
        self.frame = newFrame;
        self.tipButtonType = newTipButtonType;
    }
}

- (BOOL)isOverBounds:(CGRect)frame {
    BOOL flag = NO;
    if (CGOriginX(frame) < 0) {
        frame.origin.x = 0;
        flag = YES;
    }
    
    if (CGOriginX(frame) + CGWidth(frame) > CGWidth(self.superview.frame)) {
        frame.origin.x = CGWidth(self.superview.frame) - CGWidth(frame);
        flag = YES;
    }
    
    if (CGOriginY(frame) < 0) {
        frame.origin.y = 0;
        flag = YES;
    }
    
    if (CGOriginY(frame) + CGHeight(frame) > CGHeight(self.superview.frame)) {
        frame.origin.y = CGHeight(self.superview.frame) - CGHeight(frame);
        flag = YES;
    }
    return flag;
}






@end
