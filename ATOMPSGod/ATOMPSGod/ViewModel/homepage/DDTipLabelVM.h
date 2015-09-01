//
//  ATOMImageTipLabelViewModel.h
//  ATOMPSGod
//
//  Created by atom on 15/3/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATOMImageTipLabel;

@interface DDTipLabelVM : NSObject

/**
 *  标签内容
 */
@property (nonatomic, copy) NSString *content;
/**
 *  标签小圆点的x
 */
@property (nonatomic, assign) CGFloat x;
/**
 *  标签小圆点的y
 */
@property (nonatomic, assign) CGFloat y;
/**
 *  标签方向
 */
@property (nonatomic, assign) NSInteger labelDirection;

- (void)setViewModelData:(ATOMImageTipLabel *)tipLabel;
- (CGRect)getFrame:(CGSize)imageSize;

@end
