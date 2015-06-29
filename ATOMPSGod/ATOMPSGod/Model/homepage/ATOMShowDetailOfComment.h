//
//  ATOMShowDetailOfComment.h
//  ATOMPSGod
//
//  Created by atom on 15/3/31.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMShowDetailOfComment : NSObject

- (NSURLSessionDataTask *)ShowDetailOfComment:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error))block;
- (NSURLSessionDataTask *)SendComment:(NSDictionary *)param withBlock:(void (^)(NSInteger comment_id, NSError *error))block;
- (NSURLSessionDataTask *)toggleLike:(NSDictionary *)param withID:(NSInteger)commentID withBlock:(void (^)(NSError *))block;
@end
