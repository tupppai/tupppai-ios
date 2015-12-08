//
//  ATOMReportModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/6/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

//#import "DDSessionManager.h"
#import "ATOMReportModel.h"
@implementation ATOMReportModel

+ (NSURLSessionDataTask *)report :(NSDictionary*)param withBlock:(void (^)(NSError *))block {
    return [[DDSessionManager shareHTTPSessionManager] POST:@"inform/report_abuse" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
        if (ret == 1) {
            if (block) {
                block(nil);
            }
        } else {
            if (block) {
                block(nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (block) {
            block(error);
        }
    }];
}
@end