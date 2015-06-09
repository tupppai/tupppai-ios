//
//  ATOMBaseRequest.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseRequest.h"
#import "ATOMHTTPRequestOperationManager.h"

@implementation ATOMBaseRequest
- (AFHTTPRequestOperation *)toggleLike:(NSDictionary *)param withUrl:(NSString*)fUrl withID:(NSInteger)imageID  withBlock:(void (^)(NSError *))block {
    NSString* url = [NSString stringWithFormat:@"%@/%ld",fUrl,(long)imageID];
    NSLog(@"param %@, url %@",param,url);
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger ret = [(NSString*)responseObject[@"ret"] integerValue];
        if (ret == 1) {
            if (block) {
                block(nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(error);
        }
    }];
}
@end
