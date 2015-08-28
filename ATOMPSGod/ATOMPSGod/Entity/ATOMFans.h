//
//  ATOMFans.h
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseModel.h"

@interface ATOMFans : ATOMBaseModel

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
@property (nonatomic, assign) NSInteger fansCount;
/**
 *  求P总数
 */
@property (nonatomic, assign) NSInteger askCount;
/**
 *  回复总数
 */
@property (nonatomic, assign) NSInteger replyCount;
/**
 *  自身是否已经关注了该用户
 */
@property (nonatomic, assign) bool isFollow;


@end
