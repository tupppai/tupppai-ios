//
//  ATOMImageTipLabel.h
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseModel.h"

@interface ATOMImageTipLabel : ATOMBaseModel <MTLFMDBSerializing>

/**
 *  求P ID
 */
@property (nonatomic, assign) NSInteger imageID;
/**
 *  标签ID
 */
@property (nonatomic, assign) NSInteger labelID;
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




































@end
