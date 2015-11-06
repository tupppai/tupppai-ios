//
//  ATOMShowDetailOfComment.m
//  ATOMPSGod
//
//  Created by atom on 15/3/31.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDCommentManager.h"
#import "DDSessionManager.h"
#import "PIECommentEntity.h"
#import "PIEEntityCommentReply.h"



@interface DDCommentManager ()

@end

@implementation DDCommentManager

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSURLSessionDataTask *)ShowDetailOfComment:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSMutableArray *, NSError *))block {
    return [[DDSessionManager shareHTTPSessionManager] GET:@"comment/index" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *hotCommentArray = [NSMutableArray array];
        NSMutableArray *recentCommentArray = [NSMutableArray array];
        NSArray* data = [ responseObject objectForKey:@"data"];
        if (data.count != 0) {
            NSArray *hotCommentDataArray = [ responseObject objectForKey:@"data"][@"hot_comments"];
            NSArray *recentCommentDataArray = [ responseObject objectForKey:@"data"][@"new_comments"];
            for (int i = 0; i < hotCommentDataArray.count; i++) {
                PIECommentEntity *comment = [MTLJSONAdapter modelOfClass:[PIECommentEntity class] fromJSONDictionary:hotCommentDataArray[i] error:NULL];
                comment.commentType = [param[@"type"] integerValue];
                comment.imageID = [param[@"target_id"] integerValue];
                if (comment) {
                    [hotCommentArray addObject:comment];
                }
            }
            for (int i = 0; i < recentCommentDataArray.count; i++) {
                PIECommentEntity *comment = [MTLJSONAdapter modelOfClass:[PIECommentEntity class] fromJSONDictionary:recentCommentDataArray[i] error:NULL];
                comment.commentType = [param[@"type"] integerValue];
                comment.imageID = [param[@"target_id"] integerValue];
    //            comment.atCommentArray = [NSMutableArray array];
    //            NSArray *atCommentArray = recentCommentDataArray[i][@"at_comments"];
    //            for (int j = 0; j < atCommentArray.count; j++) {
    //                ATOMAtComment *atComment = [MTLJSONAdapter modelOfClass:[ATOMAtComment class] fromJSONDictionary:atCommentArray[j] error:NULL];
    //                if (atComment) {
    //                    [comment.atCommentArray addObject:atComment];
    //                }
    //            }
                if (comment) {
                    [recentCommentArray addObject:comment];
                }
            }
            if (block) {
                block(hotCommentArray, recentCommentArray, nil);
            }
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)SendComment:(NSDictionary *)param withBlock:(void (^)(NSInteger, NSError *))block {
    return [[DDSessionManager shareHTTPSessionManager] POST:@"comment/save" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
        if (ret == 1) {
            NSInteger comment_id = [[ responseObject objectForKey:@"data"][@"id"] integerValue];
            if (block) {
                block(comment_id, nil);
            }
        } else if (ret == 0) {
            if (block) {
                block(-1, nil);
            }
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(-1, error);
        }
    }];
}

- (NSURLSessionDataTask *)toggleLike:(NSDictionary *)param withID:(NSInteger)commentID withBlock:(void (^)(NSError *))block {
    NSString* url = [NSString stringWithFormat:@"comment/upComment/%ld",(long)commentID];    
    return [[DDSessionManager shareHTTPSessionManager] GET:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        if (block) {
            block(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(error);
        }
    }];
}






































@end
