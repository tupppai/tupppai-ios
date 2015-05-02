//
//  ATOMCustomCopperView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/13.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCustomCopperView.h"

@implementation ATOMCustomCropperView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (_customCropperViewType == ATOMCustomCropperViewCircleType) {
        CGFloat centerX = CGWidth(rect) / 2;
        CGFloat centerY = CGHeight(rect) / 2;
        CGPoint center = CGPointMake(centerX, centerY);
        CGFloat radius = CGWidth(rect) / 2;
        UIBezierPath *path1 = [UIBezierPath bezierPath];
        [[UIColor colorWithHex:0x000000 andAlpha:0.7] setFill];
        [path1 moveToPoint:CGPointMake(centerX, 0)];
        [path1 addArcWithCenter:center radius:radius startAngle:3 * M_PI / 2 endAngle:M_PI clockwise:NO];
        [path1 addLineToPoint:CGPointMake(0, 0)];
        [path1 closePath];
        [path1 fill];
        
        UIBezierPath *path2 = [UIBezierPath bezierPath];
        [[UIColor colorWithHex:0x000000 andAlpha:0.7] setFill];
        [path2 moveToPoint:CGPointMake(0, centerY)];
        [path2 addArcWithCenter:center radius:radius startAngle:M_PI endAngle:M_PI / 2 clockwise:NO];
        [path2 addLineToPoint:CGPointMake(0, CGHeight(rect))];
        [path2 closePath];
        [path2 fill];
        
        UIBezierPath *path3 = [UIBezierPath bezierPath];
        [[UIColor colorWithHex:0x000000 andAlpha:0.7] setFill];
        [path3 moveToPoint:CGPointMake(centerX, CGHeight(rect))];
        [path3 addArcWithCenter:center radius:radius startAngle:M_PI / 2 endAngle:0 clockwise:NO];
        [path3 addLineToPoint:CGPointMake(CGWidth(rect), CGHeight(rect))];
        [path3 closePath];
        [path3 fill];

        UIBezierPath *path4 = [UIBezierPath bezierPath];
        [[UIColor colorWithHex:0x000000 andAlpha:0.7] setFill];
        [path4 moveToPoint:CGPointMake(CGWidth(rect), centerY)];
        [path4 addArcWithCenter:center radius:radius startAngle:0 endAngle:-M_PI / 2 clockwise:NO];
        [path4 addLineToPoint:CGPointMake(CGWidth(rect), 0)];
        [path4 closePath];
        [path4 fill];
        
        UIBezierPath *path5 = [UIBezierPath bezierPath];
        path5.lineWidth = 3;
        [[UIColor colorWithHex:0x74c3ff] setStroke];
        [path5 moveToPoint:CGPointMake(0, centerY)];
        [path5 addArcWithCenter:center radius:radius - 1.5 startAngle:M_PI endAngle:-M_PI clockwise:NO];
        [path5 stroke];
    } else {
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = 6;
        [[UIColor colorWithHex:0x74c3ff] setStroke];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(CGWidth(rect), 0)];
        [path addLineToPoint:CGPointMake(CGWidth(rect), CGHeight(rect))];
        [path addLineToPoint:CGPointMake(0, CGHeight(rect))];
        [path closePath];
        [path stroke];
        
        CGFloat littleWidth = CGWidth(rect) / 3;
        CGFloat littleHeight = CGHeight(rect) / 3;
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        linePath.lineWidth = 1;
        [[UIColor colorWithHex:0x74c3ff] setStroke];
        [linePath moveToPoint:CGPointMake(0, littleHeight)];
        [linePath addLineToPoint:CGPointMake(CGWidth(rect), littleHeight)];
        [linePath moveToPoint:CGPointMake(0, littleHeight * 2)];
        [linePath addLineToPoint:CGPointMake(CGWidth(rect), littleHeight * 2)];
        [linePath moveToPoint:CGPointMake(littleWidth, 0)];
        [linePath addLineToPoint:CGPointMake(littleWidth, CGHeight(rect))];
        [linePath moveToPoint:CGPointMake(littleWidth * 2, 0)];
        [linePath addLineToPoint:CGPointMake(littleWidth * 2, CGHeight(rect))];
        [linePath stroke];
        
        
        
    }
}

- (void)setCustomCropperViewType:(ATOMCustomCropperViewType)customCropperViewType {
    _customCropperViewType = customCropperViewType;
    [self setNeedsDisplay];
}

@end
