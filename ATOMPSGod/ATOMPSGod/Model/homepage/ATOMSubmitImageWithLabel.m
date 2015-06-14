//
//  ATOMSubmitImageWithLabel.m
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMSubmitImageWithLabel.h"
#import "ATOMImageTipLabel.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMImageTipLabelDAO.h"

@interface ATOMSubmitImageWithLabel ()



@end

@implementation ATOMSubmitImageWithLabel

- (AFHTTPRequestOperation *)SubmitImageWithLabel:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSInteger, NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] POST:@"ask/save" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *labelArray = [NSMutableArray array];
        NSArray *dictArray = responseObject[@"data"][@"labels"];
        for (int i = 0; i < dictArray.count; i++) {
            ATOMImageTipLabel *imageTipLabel = [ATOMImageTipLabel new];
            imageTipLabel.labelID = [dictArray[i][@"id"] integerValue];
            imageTipLabel.imageID = [responseObject[@"data"][@"ask_id"] integerValue];
            [labelArray addObject:imageTipLabel];
        }
        NSInteger newImageID = [responseObject[@"data"][@"ask_id"] integerValue];
        if (block) {
            block(labelArray, newImageID, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, 0, error);
        }
    }];
}

- (AFHTTPRequestOperation *)SubmitWorkWithLabel:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] POST:@"reply/save" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *labelArray = [NSMutableArray array];
        NSArray* data = responseObject[@"data"];
        if (data.count > 0) {
            NSArray *dictArray = responseObject[@"data"][@"labels"];
            for (int i = 0; i < dictArray.count; i++) {
                ATOMImageTipLabel *imageTipLabel = [ATOMImageTipLabel new];
                imageTipLabel.labelID = [dictArray[i][@"id"] integerValue];
                imageTipLabel.imageID = [responseObject[@"data"][@"ask_id"] integerValue];
                [labelArray addObject:imageTipLabel];
            }
            if (block) {
                block(labelArray, nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}





















@end
