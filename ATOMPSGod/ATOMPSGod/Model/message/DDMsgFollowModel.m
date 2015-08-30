//
//  ATOMShowConcernMessage.m
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDMsgFollowModel.h"
#import "DDSessionManager.h"
#import "ATOMConcernMessage.h"

@implementation DDMsgFollowModel

+ (void)getFollowMsg:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block {
    [DDProfileService ddGetMsg:param withBlock:^(id data) {
        if (data) {
            NSArray *dataArray = data;
            NSMutableArray *concernMessageArray = [NSMutableArray array];
            for (int i = 0; i < dataArray.count; i++) {
                ATOMConcernMessage *concernMessage = [MTLJSONAdapter modelOfClass:[ATOMConcernMessage class] fromJSONDictionary:dataArray[i] error:NULL];
                [concernMessageArray addObject:concernMessage];
            }
            if (block) { block(concernMessageArray); }
        } else {   if (block) { block(nil); } }
    }];
}
//    [[DDSessionManager shareHTTPSessionManager] GET:@"message/list" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"ShowConcernMessage responseObject%@",responseObject);
//        NSMutableArray *concernMessageArray = [NSMutableArray array];
//        NSArray *dataArray = [ responseObject objectForKey:@"data"];
//        int ret = [(NSString*)[ responseObject objectForKey:@"ret"] intValue];
//        if (ret == 1) {
//            for (int i = 0; i < dataArray.count; i++) {
//                ATOMConcernMessage *concernMessage = [MTLJSONAdapter modelOfClass:[ATOMConcernMessage class] fromJSONDictionary:dataArray[i] error:NULL];
//                [concernMessageArray addObject:concernMessage];
//            }
//            if (block) {
//                block(concernMessageArray, nil);
//            }
//        } else {
//            block(nil, nil);
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        if (block) {
//            block(nil, error);
//        }
//    }];



@end
