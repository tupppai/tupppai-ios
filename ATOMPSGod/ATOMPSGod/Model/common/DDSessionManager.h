//
//  DDSessionManager.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface DDSessionManager : AFHTTPSessionManager

+ (instancetype)shareHTTPSessionManager;
//@property (nonatomic,assign) long long timeStamp_error;
@end
