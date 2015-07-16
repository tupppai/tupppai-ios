//
//  ATOMShareModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/26/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMShareModel.h"
#import "ATOMHTTPRequestOperationManager.h"
@implementation ATOMShareModel
- (NSURLSessionDataTask *)getShareInfo:(NSDictionary *)param withBlock:(void (^)(ATOMShare *, NSError *))block {
    [[KShareManager mascotAnimator]show];
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:@"app/share" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [[KShareManager mascotAnimator]dismiss];
        NSLog(@"getShareInfo param%@",param);
        NSLog(@"getShareInfo responseObject%@",responseObject);
        NSLog(@"getShareInfo info%@",responseObject[@"info"]);

        NSInteger ret = [(NSString*)responseObject[@"ret"] integerValue];
        if (ret == 1) {
            ATOMShare *share = [MTLJSONAdapter modelOfClass:[ATOMShare class] fromJSONDictionary:responseObject[@"data"] error:NULL];
            if (block) {
                block(share, nil);
            }
        } else {
            if (block) {
                block(nil, nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[KShareManager mascotAnimator]dismiss];
        
        if (block) {
            block(nil, error);
        }
    }];
}

//
//-(void)shareOnWechatMoments:(NSInteger)id withPageType:(ATOMPageType)pageType {
//    ATOMShareModel* shareModel = [ATOMShareModel new];
//    NSMutableDictionary* param = [NSMutableDictionary new];
//    NSString* shareTypeToServer;
//    
//    [param setObject:shareTypeToServer forKey:@"share_type"];
//    [param setObject:@(pageType) forKey:@"type"];
//    [param setObject:@(id) forKey:@"target_id"];
//    [shareModel getShareInfo:param withBlock:^(ATOMShare *share, NSError *error) {
//        if (share) {
//            [self postSocialShareShareSdk:share withShareType:shareType];
//        }
//    }];
//}


@end
