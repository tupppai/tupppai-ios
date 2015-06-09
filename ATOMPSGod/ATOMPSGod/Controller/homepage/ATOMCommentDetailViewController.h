//
//  ATOMCommentDetailViewController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/4.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseViewController.h"

@interface ATOMCommentDetailViewController : ATOMBaseViewController
/**
 *  1(ask) 2(reply)
 */
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger ID;

@end
