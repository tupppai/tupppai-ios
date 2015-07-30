//
//  ATOMRecordModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/21/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMRecordModel.h"
#import "ATOMHTTPRequestOperationManager.h"

@implementation ATOMRecordModel
+ (void)record :(NSDictionary*)param withBlock:(void (^)(NSError *,NSString*))block {
    NSLog(@"ATOMCommonModel get param %@",param);
     [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:@"user/record" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"ATOMRecordModel get responseObject%@",responseObject);
        NSLog(@"ATOMRecordModel get info%@",[ responseObject objectForKey:@"info"]);
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
        if (ret == 1) {
            NSString* url = [[responseObject objectForKey:@"data"]objectForKey:@"url"];
            if (block) {
                block(nil,url);
            }
        } else {
            NSError* error = [NSError new];
            if (block) {
                block(error,nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(error,nil);
        }
    }];
}

//+ (void)download :(url)param withBlock:(void (^)(UIImage *image))block {
//    NSLog(@"ATOMCommonModel post param %@",param);
//    [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:@"user/record" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"ATOMRecordModel get responseObject%@",responseObject);
//        NSLog(@"ATOMRecordModel get info%@",[ responseObject objectForKey:@"info"]);
//        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
//        if (ret == 1) {
//            NSString* url = [[responseObject objectForKey:@"data"]objectForKey:@"url"];
//            if (block) {
////                block(nil,url);
//            }
//        } else {
//            NSError* error = [NSError new];
//            if (block) {
////                block(error,nil);
//            }
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        if (block) {
////            block(error,nil);
//        }
//    }];
//}

@end
