//
//  ATOMReplyMessage.h
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseModel.h"
@class ATOMHomeImage;

@interface ATOMReplyMessage : ATOMBaseModel

/**
 *  每一条记录的ID
 */
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) long long createTime;
/**
 *  消息类型：0（处理了你的图片）1（这位大神也处理了你的图片）
 */
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) ATOMHomeImage *homeImage;

@end
