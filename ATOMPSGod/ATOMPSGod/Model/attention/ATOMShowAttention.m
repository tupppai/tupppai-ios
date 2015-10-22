//
//  ATOMShowAttention.m
//  ATOMPSGod
//
//  Created by atom on 15/5/6.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShowAttention.h"
#import "DDSessionManager.h"
#import "ATOMReplier.h"
#import "PIECommentEntity.h"
#import "ATOMImageTipLabel.h"
#import "PIEEliteEntity.h"

@implementation ATOMShowAttention

- (NSURLSessionDataTask *)ShowAttention:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[DDSessionManager shareHTTPSessionManager] GET:@"Thread/timeline" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
        if (ret != 1) {
            block(nil, nil);
        } else {
            NSMutableArray *resultArray = [NSMutableArray array];
            NSArray *imageDataArray = [ responseObject objectForKey:@"data"];

            for (int i = 0; i < imageDataArray.count; i++) {
                PIEEliteEntity *commonImage = [MTLJSONAdapter modelOfClass:[PIEEliteEntity class] fromJSONDictionary:imageDataArray[i] error:NULL];
                [resultArray addObject:commonImage];
            }
            if (block) {
                block(resultArray, nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

















































@end
