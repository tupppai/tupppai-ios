//
//  ATOMShowReplyMessage.m
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShowReplyMessage.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMReplyMessage.h"
#import "ATOMHomeImage.h"
#import "ATOMImageTipLabel.h"

@implementation ATOMShowReplyMessage

- (AFHTTPRequestOperation *)ShowReplyMessage:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] GET:@"message/reply" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *replyMessageArray = [NSMutableArray array];
        NSArray *dataArray = responseObject[@"data"];
        int ret = [(NSString*)responseObject[@"ret"] intValue];
        if (ret == 1) {
            for (int i = 0; i < dataArray.count; i++) {
                ATOMReplyMessage *replyMessage = [MTLJSONAdapter modelOfClass:[ATOMReplyMessage class] fromJSONDictionary:dataArray[i][@"reply"] error:NULL];
                replyMessage.type = [dataArray[i][@"type"] integerValue];
                ATOMHomeImage *homeImage = [MTLJSONAdapter modelOfClass:[ATOMHomeImage class] fromJSONDictionary:dataArray[i][@"ask"] error:NULL];
                homeImage.tipLabelArray = [NSMutableArray array];
                NSArray *labelDataArray = dataArray[i][@"ask"][@"labels"];
                if (labelDataArray.count) {
                    for (int j = 0; j < labelDataArray.count; j++) {
                        ATOMImageTipLabel *tipLabel = [MTLJSONAdapter modelOfClass:[ATOMImageTipLabel class] fromJSONDictionary:labelDataArray[j] error:NULL];
                        tipLabel.imageID = homeImage.imageID;
                        [homeImage.tipLabelArray addObject:tipLabel];
                    }
                }
                replyMessage.homeImage = homeImage;
                [replyMessageArray addObject:replyMessage];
            }
            if (block) {
                block(replyMessageArray, nil);
            }
        } else {
            block(nil, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
