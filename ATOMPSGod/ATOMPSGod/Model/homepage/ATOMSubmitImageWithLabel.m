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

@property (nonatomic, strong) ATOMImageTipLabelDAO *tipLabelDAO;

@end

@implementation ATOMSubmitImageWithLabel

- (ATOMImageTipLabelDAO *)tipLabelDAO {
    if (!_tipLabelDAO) {
        _tipLabelDAO = [ATOMImageTipLabelDAO new];
    }
    return _tipLabelDAO;
}

- (AFHTTPRequestOperation *)SubmitImageWithLabel:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] POST:@"ask/save" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *labelArray = [NSMutableArray array];
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)saveTipLabelInDB:(ATOMImageTipLabel *)tipLabel {
    [self.tipLabelDAO insertTipLabel:tipLabel];
}





















@end
