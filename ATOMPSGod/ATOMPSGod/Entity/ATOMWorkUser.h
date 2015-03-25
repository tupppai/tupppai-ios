//
//  ATOMWorkUser.h
//  ATOMPSGod
//
//  Created by atom on 15/3/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseModel.h"

@interface ATOMWorkUser : ATOMBaseModel <MTLFMDBSerializing>

/**
 *  求P ID
 */
@property (nonatomic, assign) NSInteger imageID;
/**
 *  大神ID
 */
@property (nonatomic, assign) NSInteger uid;
/**
 *  大神昵称
 */
@property (nonatomic, copy) NSString *nickname;
/**
 *  大神头像
 */
@property (nonatomic, copy) NSString *avatar;































@end
