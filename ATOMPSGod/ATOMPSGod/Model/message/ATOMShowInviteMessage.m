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

- (AFHTTPRequestOperation *)ShowInviteMessage:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] GET:@"message/invite" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *inviteMessageArray = [NSMutableArray array];
        NSArray *dataArray = responseObject[@"data"];
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
