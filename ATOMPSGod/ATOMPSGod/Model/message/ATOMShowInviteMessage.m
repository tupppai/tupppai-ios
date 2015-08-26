//
//  ATOMShowInviteMessage.m
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShowInviteMessage.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMHomeImage.h"
#import "ATOMInviteMessage.h"
#import "ATOMImageTipLabel.h"

@implementation ATOMShowInviteMessage

- (NSURLSessionDataTask *)ShowInviteMessage:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:@"message/list" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"ShowInviteMessage responseObject%@",responseObject);
        NSMutableArray *inviteMessageArray = [NSMutableArray array];
        NSArray *dataArray = [ responseObject objectForKey:@"data"];
        int ret = [(NSString*)[ responseObject objectForKey:@"ret"] intValue];
        if (ret == 1) {
            for (int i = 0; i < dataArray.count; i++) {
                ATOMInviteMessage *inviteMessage = [MTLJSONAdapter modelOfClass:[ATOMInviteMessage class] fromJSONDictionary:dataArray[i][@"inviter"] error:NULL];
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
                inviteMessage.homeImage = homeImage;
                [inviteMessageArray addObject:inviteMessage];
            }
            if (block) {
                block(inviteMessageArray, nil);
            }
        } else {
            if (block) {
                block(nil, nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
