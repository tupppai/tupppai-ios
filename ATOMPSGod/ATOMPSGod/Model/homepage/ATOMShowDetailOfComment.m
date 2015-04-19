//
//  ATOMShowDetailOfComment.m
//  ATOMPSGod
//
//  Created by atom on 15/3/31.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShowDetailOfComment.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMComment.h"
#import "ATOMAtComment.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMShowDetailOfComment ()



@end

@implementation ATOMShowDetailOfComment

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (AFHTTPRequestOperation *)ShowDetailOfComment:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSMutableArray *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] GET:@"comment/index" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *hotCommentArray = [NSMutableArray array];
        NSMutableArray *recentCommentArray = [NSMutableArray array];
        NSArray *hotCommentDataArray = responseObject[@"data"][@"hot_comments"];
        NSArray *recentCommentDataArray = responseObject[@"data"][@"new_comments"];
        for (int i = 0; i < hotCommentDataArray.count; i++) {
            ATOMComment *comment = [MTLJSONAdapter modelOfClass:[ATOMComment class] fromJSONDictionary:hotCommentDataArray[i] error:NULL];
            comment.commentType = [param[@"type"] integerValue];
            comment.imageID = [param[@"target_id"] integerValue];
            [hotCommentArray addObject:comment];
        }
        for (int i = 0; i < recentCommentDataArray.count; i++) {
            ATOMComment *comment = [MTLJSONAdapter modelOfClass:[ATOMComment class] fromJSONDictionary:recentCommentDataArray[i] error:NULL];
            comment.commentType = [param[@"type"] integerValue];
            comment.imageID = [param[@"target_id"] integerValue];
            comment.atCommentArray = [NSMutableArray array];
            NSArray *atCommentArray = recentCommentDataArray[i][@"at_comments"];
            for (int j = 0; j < atCommentArray.count; j++) {
                ATOMAtComment *atComment = [MTLJSONAdapter modelOfClass:[ATOMAtComment class] fromJSONDictionary:atCommentArray[j] error:NULL];
                [comment.atCommentArray addObject:atComment];
            }
            [recentCommentArray addObject:comment];
        }
        if (block) {
            block(hotCommentArray, recentCommentArray, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, nil, error);
        }
    }];
}

- (AFHTTPRequestOperation *)SendComment:(NSDictionary *)param withBlock:(void (^)(NSInteger, NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] POST:@"comment/send_comment" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger comment_id = [responseObject[@"data"][@"id"] integerValue];
        if (block) {
            block(comment_id, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(-1, error);
        }
    }];
}

- (AFHTTPRequestOperation *)PraiseComment:(NSDictionary *)param withBlock:(void (^)(NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] POST:@"comment/praise" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) {
            block(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(error);
        }
    }];
}






































@end
