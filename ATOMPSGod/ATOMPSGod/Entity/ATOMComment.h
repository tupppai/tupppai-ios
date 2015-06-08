//
//  ATOMComment.h
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseModel.h"

@interface ATOMComment : ATOMBaseModel <MTLFMDBSerializing>

/**
 *  求P ID
 */
@property (nonatomic, assign) NSInteger imageID;
/**
 *  回复ID （详情）
 */
@property (nonatomic, assign) NSInteger detailID;
/**
 *  评论ID
 */
@property (nonatomic, assign) NSInteger cid;
/**
 *  评论内容
 */
@property (nonatomic, copy) NSString *content;
/**
 *  评论时间
 */
@property (nonatomic, assign) long long commentTime;
/**
 *  评论获赞数
 */
@property (nonatomic, assign) NSInteger praiseNumber;
/**
 *  评论类型 0：ask 1：reply
 */
@property (nonatomic, assign) NSInteger commentType;
/**
 *  评论人ID
 */
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger sex;
/**
 *  @数组
 */
@property (nonatomic, strong) NSMutableArray *atCommentArray;
@property (nonatomic, assign) BOOL liked;
@end
