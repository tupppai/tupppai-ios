//
//  ATOMShowAskOrReply.m
//  ATOMPSGod
//
//  Created by atom on 15/4/7.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShowAskOrReply.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMHomeImage.h"
#import "ATOMImageTipLabel.h"

@implementation ATOMShowAskOrReply

- (AFHTTPRequestOperation *)ShowAskOrReply:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] GET:@"index/index" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *resultArray = [NSMutableArray array];
        NSArray *imageDataArray = responseObject[@"data"];
        int ret = [(NSString*)responseObject[@"ret"] intValue];
        if (ret == 1) {
            for (int i = 0; i < imageDataArray.count; i++) {
                ATOMHomeImage *homeImage = [MTLJSONAdapter modelOfClass:[ATOMHomeImage class] fromJSONDictionary:imageDataArray[i] error:NULL];
                homeImage.tipLabelArray = [NSMutableArray array];
                NSArray *labelDataArray = imageDataArray[i][@"labels"];
                if (labelDataArray.count) {
                    for (int j = 0; j < labelDataArray.count; j++) {
                        ATOMImageTipLabel *tipLabel = [MTLJSONAdapter modelOfClass:[ATOMImageTipLabel class] fromJSONDictionary:labelDataArray[j] error:NULL];
                        tipLabel.imageID = homeImage.imageID;
                        [homeImage.tipLabelArray addObject:tipLabel];
                    }
                }
                [resultArray addObject:homeImage];
            }
            if (block) {
                block(resultArray, nil);
            }
        } else {
            if (block) {
                block(nil, nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
