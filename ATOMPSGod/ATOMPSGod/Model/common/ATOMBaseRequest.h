//
//  ATOMBaseRequest.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMBaseRequest : NSObject
+ (NSURLSessionDataTask *)toggleLike:(NSDictionary *)param withPageType:(ATOMPageType)type withID:(NSInteger)ID  withBlock:(void (^)(NSError *))block;

- (NSURLSessionDataTask *)toggleLike:(NSDictionary *)param withUrl:(NSString*)fUrl withID:(NSInteger)imageID  withBlock:(void (^)(NSError *))block;

@end
