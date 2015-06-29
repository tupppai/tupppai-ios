//
//  ATOMShowConcern.m
//  ATOMPSGod
//
//  Created by atom on 15/4/15.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShowConcern.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMConcern.h"

@implementation ATOMShowConcern

- (NSURLSessionDataTask *)ShowMyConcern:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSMutableArray *, NSError *))block {
    [[KShareManager mascotAnimator]show];
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:@"user/myfellow" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [[KShareManager mascotAnimator]dismiss];
        NSLog(@"ShowMyConcern responseObject %@",responseObject);
        int ret = [(NSString*)responseObject[@"ret"] intValue];
        if (ret == 1) {
            NSMutableArray *recommendConcernArray = [NSMutableArray array];
            NSMutableArray *myConcernArray = [NSMutableArray array];
            NSArray *recommendDataArray = responseObject[@"data"][@"recommends"];
            NSArray *myDataArray = responseObject[@"data"][@"felows"];
            for (int i = 0; i < recommendDataArray.count; i++) {
                ATOMConcern *concern = [MTLJSONAdapter modelOfClass:[ATOMConcern class] fromJSONDictionary:recommendDataArray[i] error:NULL];
                [recommendConcernArray addObject:concern];
            }
            for (int i = 0; i < myDataArray.count; i++) {
                ATOMConcern *concern = [MTLJSONAdapter modelOfClass:[ATOMConcern class] fromJSONDictionary:myDataArray[i] error:NULL];
                [myConcernArray addObject:concern];
            }
            if (block) {
                block(recommendConcernArray, myConcernArray, nil);
            }
        } else {
            if (block) {
                block(nil,nil, nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)ShowOtherConcern:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:@"user/myfellow" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int ret = [(NSString*)responseObject[@"ret"] intValue];
        if (ret == 1) {
            NSMutableArray *resultArray = [NSMutableArray array];
            NSArray *dataArray = responseObject[@"data"][@"felows"];
            for (int i = 0; i < dataArray.count; i++) {
                ATOMConcern *concern = [MTLJSONAdapter modelOfClass:[ATOMConcern class] fromJSONDictionary:dataArray[i] error:NULL];
                [resultArray addObject:concern];
            }
            if (block) {
                block(resultArray, nil);
            }
        } else {
            if (block) {
                block(nil, nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}
























@end
