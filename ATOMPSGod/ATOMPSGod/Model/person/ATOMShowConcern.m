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

- (AFHTTPRequestOperation *)ShowMyConcern:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSMutableArray *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] GET:@"user/myfellow" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, nil, error);
        }
    }];
}

- (AFHTTPRequestOperation *)ShowOtherConcern:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] GET:@"user/myfellow" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *resultArray = [NSMutableArray array];
        NSArray *dataArray = responseObject[@"data"][@"felows"];
        for (int i = 0; i < dataArray.count; i++) {
            ATOMConcern *concern = [MTLJSONAdapter modelOfClass:[ATOMConcern class] fromJSONDictionary:dataArray[i] error:NULL];
            [resultArray addObject:concern];
        }
        if (block) {
            block(resultArray, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}
























@end
