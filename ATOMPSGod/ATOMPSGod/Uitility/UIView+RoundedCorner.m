//
//  UIView+RoundedCorner.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/24/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "UIView+RoundedCorner.h"

@implementation UIView (RoundedCorner)

- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius
{
    CGRect rect = self.bounds;
    
    // create the path
    UIBezierPath *maskPath =
    [UIBezierPath bezierPathWithRoundedRect:rect
                          byRoundingCorners:corners
                                cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    
    // set the newly created shape layer as the mask for the view's layer
    self.layer.mask = maskLayer;
}

@end
