//
//  PIENotificationOriginalCommentLabel.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/14/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENotificationOriginalCommentLabel.h"

@implementation PIENotificationOriginalCommentLabel

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = UIEdgeInsetsMake(9, 8, 9, 8);
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    
    size.width += 9;
    size.height += 8;
    return size;
}

//- (CGRect)textRectForBounds:(CGRect)bounds
//     limitedToNumberOfLines:(NSInteger)numberOfLines
//{
//    UIEdgeInsets insets = UIEdgeInsetsMake(9, 8, 9, 8);
//    
//    CGRect rect =
//    [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
//      limitedToNumberOfLines:numberOfLines];
//    
//    rect.origin.x    -= insets.left;
//    rect.origin.y    -= insets.top;
//    rect.size.width  += (insets.left + insets.right);
//    rect.size.height += (insets.top + insets.bottom);
//    
//    return rect;
//}

@end
