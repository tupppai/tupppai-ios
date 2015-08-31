//
//  ATOMInviteModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/24/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "DDInviteManager.h"
#import "DDSessionManager.h"
#import "ATOMRecommendUser.h"
@implementation DDInviteManager

+ (NSURLSessionDataTask *)invite:(NSDictionary *)param {
    return [[DDSessionManager shareHTTPSessionManager] GET:@"invitation/invite" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
        if (ret != 1) {
            
        } else {
        }
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"invite error %@",error);
    }];
}
@end

