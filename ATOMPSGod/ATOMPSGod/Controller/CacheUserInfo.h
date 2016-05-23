//
//  UserInfoModel.h
//  YouzaniOSDemo
//
//  Created by youzan on 15/11/6.
//  Copyright (c) 2015年 youzan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZUserModel.h"

@interface CacheUserInfo : NSObject

@property (copy, nonatomic  ) NSString *userId;
@property (copy, nonatomic  ) NSString *gender;
@property (copy, nonatomic  ) NSString *bid;
@property (copy, nonatomic  ) NSString *name;
@property (copy, nonatomic  ) NSString *telephone;
@property (copy, nonatomic  ) NSString *avatar;
@property (copy, nonatomic  ) NSString *ipAddress;
@property (assign, nonatomic) BOOL     isLogined;

//这里注意看下，因为session存在被服务端退出的情况，所以这里处理的isValid长期缓存，并且在webview退出时，处理成NO，
@property (assign, nonatomic) BOOL isValid;//标示使用接口返回的结果是否验证通过

+ (instancetype)sharedManage;

/**
 *  模式值设置
 */
- (void) defaultValue ;//测试数据

/**
 *  数据模型转换
 *
 *  @param cacheModel 缓存数据模型
 *
 *  @return YZUserModel
 */
+ (YZUserModel *) getYZUserModelFromCacheUserModel:(CacheUserInfo *)cacheModel;

@end
