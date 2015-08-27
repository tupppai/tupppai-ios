//
//  ATOMBaseRequest.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDBaseService : NSObject
+ (NSURLSessionDataTask *)toggleLike:(NSDictionary *)param withPageType:(ATOMPageType)type withID:(NSInteger)ID  withBlock:(void (^)(NSError *))block;
+ (void)toggleLike:(NSDictionary *)param withType:(ATOMPageType)type withID:(NSInteger)ID  withBlock:(void (^)(NSError *))block;
+ (void)downloadImage:(NSString*)url withBlock:(void (^)(UIImage* image))block;

+ (NSURLSessionDataTask *)get :(NSDictionary*)param withUrl:(NSString*)url withBlock:(void (^)(NSError *))block;
+ (NSURLSessionDataTask *)post :(NSDictionary*)param withUrl:(NSString*)url withBlock:(void (^)(NSError *error ,int ret))block;
+ (NSURLSessionDataTask *)GET :(NSDictionary*)param withUrl:(NSString*)url withBlock:(void (^)(id responseObject))block;
@end
