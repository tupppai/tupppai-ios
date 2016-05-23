//
//  UserInfoModel.m
//  YouzaniOSDemo
//
//  Created by youzan on 15/11/6.
//  Copyright (c) 2015年 youzan. All rights reserved.
//

#import "CacheUserInfo.h"

@implementation CacheUserInfo

+ (instancetype)sharedManage {
    static CacheUserInfo *shareManage = nil;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        shareManage = [[self alloc] init];
        [shareManage defaultValue];
    });
    return shareManage;
}

- (id) init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

#pragma mark - default value
- (void) defaultValue {
    
    [self setProperty:@"gender" Value:@"1"];
    [self setProperty:@"bid" Value:@"111111err"];
    [self setProperty:@"name" Value:@"yid111111a"];
    [self setProperty:@"telephone" Value:@"13605809612"];
    [self setProperty:@"avatar" Value:@""];
    [self setProperty:@"isLogined" Value:@"YES"];
    _isValid = NO;
}

#pragma mark - 数据转化
+ (YZUserModel *) getYZUserModelFromCacheUserModel:(CacheUserInfo *)cacheModel {
    
    YZUserModel *userModel = [[YZUserModel alloc] init];
    userModel.userID = cacheModel.bid;
    userModel.userName = cacheModel.name;
    userModel.nickName = cacheModel.name;
    userModel.gender = cacheModel.gender;
    userModel.avatar = cacheModel.avatar;
    userModel.telePhone = cacheModel.telephone;
    return userModel;
}

#pragma mark - setter cache
- (void)setGender:(NSString *)gender {
    [self setProperty:@"gender" Value:gender];
}
- (void)setBid:(NSString *)bid {
    [self setProperty:@"bid" Value:bid];
}
- (void)setName:(NSString *)name {
    [self setProperty:@"name" Value:name];
}
- (void)setTelephone:(NSString *)telephone {
    [self setProperty:@"telephone" Value:telephone];
}
- (void)setAvatar:(NSString *)avatar {
    [self setProperty:@"avatar" Value:avatar];
}

- (void)setProperty:(NSString *)key Value:(NSString *)value {
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setIpAddress:(NSString *)ipAddress {
    [self setProperty:@"ipaddress" Value:ipAddress];
}

- (void)setIsLogined:(BOOL)isLogined {
    if(isLogined) {
        [self setProperty:@"isLogined" Value:@"YES"];
    } else {
        [self setProperty:@"isLogined" Value:@"NO"];
    }
}

#pragma mark - getter
- (NSString *)gender {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
}

- (NSString *)bid {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"bid"];
}

- (NSString *)name {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
}

- (NSString *)telephone {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"telephone"];
}

- (NSString *)avatar {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
}

- (NSString *)ipAddress {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ipaddress"];
}

- (BOOL) isLogined {
    NSString *isLogined = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogined"];
    if(isLogined == nil || isLogined.length == 0) {
        return NO;
    }
    return [isLogined isEqualToString:@"YES"];
}



@end
