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

- (NSURLSessionDataTask *)ShowCommentMessage:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    [[KShareManager mascotAnimator]show];
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:@"message/comment" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [[KShareManager mascotAnimator]dismiss];
        NSLog(@"ShowCommentMessage responseObject%@",responseObject);
        NSMutableArray *commentMessageArray = [NSMutableArray array];
        NSArray *dataArray = responseObject[@"data"];
        int ret = [(NSString*)responseObject[@"ret"] intValue];
        if (ret == 1) {
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
        } else {
            if (block) {
                block(nil, nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[KShareManager mascotAnimator]dismiss];
        [Util TextHud:@"出现未知错误"];
        if (block) {
            block(nil, error);
        }
    }];
}

@end
