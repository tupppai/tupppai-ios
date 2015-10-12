//
//  ATOMSubmitUserInfomation.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDPageManager : NSObject
+ (void)getPhotos:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block;
+ (void)getAsk:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block ;
+ (void)getReply:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block;
+ (void)getCollection:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block;
@end
