//
//  ATOMShowInviteMessage.m
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDMsgInviteModel.h"
#import "DDSessionManager.h"
#import "ATOMAskPage.h"
#import "ATOMInviteMessage.h"
#import "ATOMImageTipLabel.h"

@implementation DDMsgInviteModel

+ (void)getInviteMsg:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block {
    [DDService ddGetMsg:param withBlock:^(id data) {
        if (data) {
            NSArray *dataArray = data;
            NSMutableArray *inviteMessageArray = [NSMutableArray array];
            for (int i = 0; i < dataArray.count; i++) {
                ATOMInviteMessage *inviteMessage = [MTLJSONAdapter modelOfClass:[ATOMInviteMessage class] fromJSONDictionary:[[dataArray objectAtIndex:i]objectForKey:@"inviter"] error:NULL];
                ATOMAskPage *homeImage = [MTLJSONAdapter modelOfClass:[ATOMAskPage class] fromJSONDictionary:[[dataArray objectAtIndex:i]objectForKey:@"ask"] error:NULL];
                homeImage.tipLabelArray = [NSMutableArray array];
                NSArray *labelDataArray = [[[dataArray objectAtIndex:i]objectForKey:@"ask"]objectForKey:@"labels"];
                if (labelDataArray.count) {
                    for (int j = 0; j < labelDataArray.count; j++) {
                        ATOMImageTipLabel *tipLabel = [MTLJSONAdapter modelOfClass:[ATOMImageTipLabel class] fromJSONDictionary:labelDataArray[j] error:NULL];
                        tipLabel.imageID = homeImage.imageID;
                        [homeImage.tipLabelArray addObject:tipLabel];
                    }
                }
                inviteMessage.homeImage = homeImage;
                [inviteMessageArray addObject:inviteMessage];
            }
            if (block) { block(inviteMessageArray);}
        } else { if (block) { block(nil);} }
    }];
}
//     [[DDSessionManager shareHTTPSessionManager] GET:@"message/list" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSMutableArray *inviteMessageArray = [NSMutableArray array];
//        NSArray *dataArray = [ responseObject objectForKey:@"data"];
//        int ret = [(NSString*)[ responseObject objectForKey:@"ret"] intValue];
//        if (ret == 1) {
//            for (int i = 0; i < dataArray.count; i++) {
//                ATOMInviteMessage *inviteMessage = [MTLJSONAdapter modelOfClass:[ATOMInviteMessage class] fromJSONDictionary:dataArray[i][@"inviter"] error:NULL];
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
//                inviteMessage.homeImage = homeImage;
//                [inviteMessageArray addObject:inviteMessage];
//            }
//            if (block) {
//                block(inviteMessageArray, nil);
//            }
//        } else {
//            if (block) {
//                block(nil, nil);
//            }
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        if (block) {
//            block(nil, error);
//        }
//    }];
//}

@end
