//
//  ATOMLogin.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATOMUser;

@interface ATOMLogin : NSObject

- (AFHTTPRequestOperation *)openIDAuth:(NSDictionary *)param AndType:(NSString *)type withBlock:(void (^)(bool isRegister,NSString* info, NSError *error))block;
- (void)thirdPartyAuth:(ShareType)type withBlock:(void (^)(NSDictionary* sourceData))block;
- (AFHTTPRequestOperation* )Login:(NSDictionary*)param withBlock:(void (^)(BOOL succeed))block;
@end
