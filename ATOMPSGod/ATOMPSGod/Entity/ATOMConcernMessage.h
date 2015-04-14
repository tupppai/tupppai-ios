//
//  ATOMConcernMessage.h
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseModel.h"

@interface ATOMConcernMessage : ATOMBaseModel

/**
 *  每一条记录的ID
 */
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) long long createTime;

@end
