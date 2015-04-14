//
//  ATOMShowCommentMessage.m
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShowCommentMessage.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMCommentMessage.h"
#import "ATOMHomeImage.h"
#import "ATOMImageTipLabel.h"

@implementation ATOMShowCommentMessage

- (AFHTTPRequestOperation *)ShowCommentMessage:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] GET:@"message/comment" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *commentMessageArray = [NSMutableArray array];
        NSArray *dataArray = responseObject[@"data"];
        for (int i = 0; i < dataArray.count; i++) {
            ATOMCommentMessage *commentMessage = [MTLJSONAdapter modelOfClass:[ATOMCommentMessage class] fromJSONDictionary:dataArray[i][@"comment"] error:NULL];
            commentMessage.type = [dataArray[i][@"type"] integerValue];
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
            commentMessage.homeImage = homeImage;
            [commentMessageArray addObject:commentMessage];
        }
        if (block) {
            block(commentMessageArray, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
