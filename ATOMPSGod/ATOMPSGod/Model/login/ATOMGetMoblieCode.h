//
//  ATOMGetMoblieCode.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMGetMoblieCode : NSObject

- (AFHTTPRequestOperation *)GetMobileCode:(NSDictionary *)param withBlock:(void (^)(NSString *verifyCode, NSError *error))block;

@end
