//
//  ATOMSubmitUserInfomation.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDAccountModel : NSObject

+ (void )DDRegister:(NSDictionary *)param withBlock:(void (^)(BOOL success))block ;
+ (void )DDLogin:(NSDictionary*)param withBlock:(void (^)(BOOL succeed))block ;
+ (void)DD3PartyAuth:(NSDictionary *)param AndType:(NSString *)type withBlock:(void (^)(bool isRegistered,NSString* info))block;
@end
