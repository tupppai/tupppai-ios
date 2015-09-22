//
//  ATOMShowReplyMessage.m
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDMsgReplyModel.h"
#import "DDSessionManager.h"
#import "ATOMReplyMessage.h"
#import "PIEPageEntity.h"
#import "ATOMImageTipLabel.h"

@implementation DDMsgReplyModel
//
//- (NSURLSessionDataTask *)ShowReplyMessage:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
//    return [[DDSessionManager shareHTTPSessionManager] GET:@"message/list" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSMutableArray *replyMessageArray = [NSMutableArray array];
//        NSArray *dataArray = [ responseObject objectForKey:@"data"];
//        int ret = [(NSString*)[ responseObject objectForKey:@"ret"] intValue];
//        if (ret == 1) {
//            for (int i = 0; i < dataArray.count; i++) {
//                ATOMReplyMessage *replyMessage = [MTLJSONAdapter modelOfClass:[ATOMReplyMessage class] fromJSONDictionary:dataArray[i][@"reply"] error:NULL];
//                replyMessage.type = [dataArray[i][@"type"] integerValue];
//                ATOMHomeImage *homeImage = [MTLJSONAdapter modelOfClass:[ATOMHomeImage class] fromJSONDictionary:dataArray[i][@"ask"] error:NULL];
//                homeImage.tipLabelArray = [NSMutableArray array];
//                NSArray *labelDataArray = dataArray[i][@"ask"][@"labels"];
//                if (labelDataArray.count) {
//                    for (int j = 0; j < labelDataArray.count; j++) {
//                        ATOMImageTipLabel *tipLabel = [MTLJSONAdapter modelOfClass:[ATOMImageTipLabel class] fromJSONDictionary:labelDataArray[j] error:NULL];
//                        tipLabel.imageID = homeImage.imageID;
//                        [homeImage.tipLabelArray addObject:tipLabel];
//                    }
//                }
//                replyMessage.homeImage = homeImage;
//                [replyMessageArray addObject:replyMessage];
//            }
//            if (block) {
//                block(replyMessageArray, nil);
//            }
//        } else {
//            block(nil, nil);
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        if (block) {
//            block(nil, error);
//        }
//    }];
//}


+ (void)getReplyMsg:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block {
    
    [DDService ddGetMsg:param withBlock:^(id data) {
        if (data) {
            NSArray *dataArray = data;
            NSMutableArray *replyMsgArray = [NSMutableArray array];
            for (int i = 0; i < dataArray.count; i++) {
                ATOMReplyMessage *replyMessage = [MTLJSONAdapter modelOfClass:[ATOMReplyMessage class] fromJSONDictionary:[[dataArray objectAtIndex:i] objectForKey:@"reply"] error:NULL];
                replyMessage.type = [[[dataArray objectAtIndex:i] objectForKey:@"type"] integerValue];
                PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:[[dataArray objectAtIndex:i] objectForKey:@"ask"] error:NULL];
//                homeImage.tipLabelArray = [NSMutableArray array];
//                NSArray *labelDataArray = [[[dataArray objectAtIndex:i] objectForKey:@"ask"]objectForKey:@"labels"];
//                if (labelDataArray.count) {
//                    for (int j = 0; j < labelDataArray.count; j++) {
//                        ATOMImageTipLabel *tipLabel = [MTLJSONAdapter modelOfClass:[ATOMImageTipLabel class] fromJSONDictionary:labelDataArray[j] error:NULL];
//                        tipLabel.imageID = homeImage.imageID;
//                        [homeImage.tipLabelArray addObject:tipLabel];
//                    }
//                }
                replyMessage.homeImage = homeImage;
                [replyMsgArray addObject:replyMessage];
            }
            if (block) {  block(replyMsgArray); }
        } else {if (block) {  block(nil); }}
    }];
}

@end
