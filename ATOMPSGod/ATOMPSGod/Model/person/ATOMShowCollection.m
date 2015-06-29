//
//  ATOMShowCollection.m
//  ATOMPSGod
//
//  Created by atom on 15/4/8.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShowCollection.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMHomeImage.h"
#import "ATOMImageTipLabel.h"

@implementation ATOMShowCollection

- (NSURLSessionDataTask *)ShowCollection:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    [[KShareManager mascotAnimator]show];
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:@"index/index" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [[KShareManager mascotAnimator]dismiss];
        NSLog(@"ShowCollection responseObject %@",responseObject);
        int ret = [(NSString*)responseObject[@"ret"] intValue];
        if (ret == 1) {
            NSMutableArray *resultArray = [NSMutableArray array];
            NSArray *imageDataArray = responseObject[@"data"];
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
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[KShareManager mascotAnimator]dismiss];
        if (block) {
            block(nil, error);
        }
    }];
}

@end
