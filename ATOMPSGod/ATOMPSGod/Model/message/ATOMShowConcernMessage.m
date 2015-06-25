//
//  ATOMShowConcernMessage.m
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShowConcernMessage.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMConcernMessage.h"

@implementation ATOMShowConcernMessage

- (AFHTTPRequestOperation *)ShowConcernMessage:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    [[KShareManager mascotAnimator]show];
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] GET:@"message/follow" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[KShareManager mascotAnimator]dismiss];
        NSLog(@"ShowConcernMessage responseObject%@",responseObject);
        NSMutableArray *concernMessageArray = [NSMutableArray array];
        NSArray *dataArray = responseObject[@"data"];
        int ret = [(NSString*)responseObject[@"ret"] intValue];
        if (ret == 1) {
            for (int i = 0; i < dataArray.count; i++) {
                ATOMConcernMessage *concernMessage = [MTLJSONAdapter modelOfClass:[ATOMConcernMessage class] fromJSONDictionary:dataArray[i] error:NULL];
                [concernMessageArray addObject:concernMessage];
            }
            if (block) {
                block(concernMessageArray, nil);
            }
        } else {
            block(nil, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[KShareManager mascotAnimator]dismiss];
        if (block) {
            block(nil, error);
        }
    }];
}

@end
