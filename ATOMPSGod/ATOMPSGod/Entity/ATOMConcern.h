//
//  ATOMConcern.h
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseModel.h"

@interface ATOMConcern : ATOMBaseModel

/**
 *  每一条记录的ID
 */
@property (nonatomic, assign) NSInteger fid;
/**
 *  用户ID
 */
@property (nonatomic, assign) NSInteger uid;
/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger sex;
/**
 *  粉丝总数
 */
@property (nonatomic, assign) NSInteger totalFansNumber;
/**
 *  求P总数
 */
@property (nonatomic, assign) NSInteger totalAskNumber;
/**
 *  回复总数
 */
@property (nonatomic, assign) NSInteger totalReplyNumber;
/**
 *  关注状态，0（未关注）1（已关注）2（相互关注）
 */
@property (nonatomic, assign) NSInteger concernStatus;

@end
