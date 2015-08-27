//
//  ATOMSubmitImageWithLabel.m
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMSubmitImageWithLabel.h"
#import "ATOMImageTipLabel.h"
#import "DDSessionManager.h"
#import "ATOMImageTipLabelDAO.h"

@interface ATOMSubmitImageWithLabel ()



@end

@implementation ATOMSubmitImageWithLabel

- (NSURLSessionDataTask *)SubmitImageWithLabel:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSInteger, NSError *))block {
    return [[DDSessionManager shareHTTPSessionManager] POST:@"ask/save" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger newImageID = [[ responseObject objectForKey:@"data"][@"ask_id"] integerValue];
        if (block) {
            block(nil, newImageID, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, 0, error);
        }
    }];
}

- (NSURLSessionDataTask *)SubmitWorkWithLabel:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[DDSessionManager shareHTTPSessionManager] POST:@"reply/save" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [[KShareManager mascotAnimator]dismiss];
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
        if (ret == 1) {
            NSMutableArray *labelArray = [NSMutableArray array];
            NSArray* data = [ responseObject objectForKey:@"data"];
            if (data.count > 0) {
                NSArray *dictArray = [ responseObject objectForKey:@"data"][@"labels"];
                for (int i = 0; i < dictArray.count; i++) {
                    ATOMImageTipLabel *imageTipLabel = [ATOMImageTipLabel new];
                    imageTipLabel.labelID = [dictArray[i][@"id"] integerValue];
                    imageTipLabel.imageID = [[ responseObject objectForKey:@"data"][@"ask_id"] integerValue];
                    [labelArray addObject:imageTipLabel];
                }
                if (block) {
                    block(labelArray, nil);
                }
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
