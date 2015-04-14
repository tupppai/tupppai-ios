//
//  ATOMCommentMessage.h
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseModel.h"
@class ATOMHomeImage;

@interface ATOMCommentMessage : ATOMBaseModel

/**
 *  每一条记录的ID
 */
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) long long createTime;
@property (nonatomic, copy) NSString *content;
/**
 *  消息类型：0（评论你）1（回复你）
 */
@property (nonatomic, assign) NSInteger type;
/**
 *  评论类型：1（ask）2（reply）
 */
@property (nonatomic, assign) NSInteger commentType;
@property (nonatomic, strong) ATOMHomeImage *homeImage;

@end
