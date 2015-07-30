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

- (NSURLSessionDataTask *)ShowReplyMessage:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:@"message/reply" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"ShowReplyMessage responseObject%@",responseObject);
        NSMutableArray *replyMessageArray = [NSMutableArray array];
        NSArray *dataArray = [ responseObject objectForKey:@"data"];
        int ret = [(NSString*)[ responseObject objectForKey:@"ret"] intValue];
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
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
