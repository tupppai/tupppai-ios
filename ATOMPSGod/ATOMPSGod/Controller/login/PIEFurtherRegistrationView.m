//
//  PIEFurtherRegistrationView.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/8/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEFurtherRegistrationView.h"

@implementation PIEFurtherRegistrationView


#pragma mark - Overriden methods
/**
    重写hitTest: 放宽条件，不要求一定要在自己view的边框之内，
                这样subview即使不在自己的可视范围之内也可以响应事件了
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.clipsToBounds && !self.hidden && self.alpha > 0) {
        for (UIView *subview in self.subviews.reverseObjectEnumerator) {
            CGPoint subPoint = [subview convertPoint:point fromView:self];
            UIView *result = [subview hitTest:subPoint withEvent:event];
            if (result != nil) {
                return result;
            }
        }
    }
    return nil;
}

@end
