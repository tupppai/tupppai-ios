//
//  PIEMyWalletManager.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/16/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEMyWalletManager.h"
#import "PIECashFlowModel.h"
@implementation PIEMyWalletManager

+ (void)transactionDetails:(NSDictionary *)params
                     block:(void (^)(NSArray<PIECashFlowModel *> *))block
                   failure:(void (^)(void))failureBlock
{
    [DDBaseService GET:params
                   url:@"profile/transactions"
                 block:^(id responseObject) {
                     if (responseObject == nil) {
                         if (failureBlock != nil) {
                             failureBlock();
                         }
                     }
                     else
                     {
                         NSArray<PIECashFlowModel *> *retArray =
                         [NSArray<PIECashFlowModel *> array];
                         
                         NSArray<NSDictionary *> *dataDicts =
                         responseObject[@"data"];
                         
                         retArray =
                         [MTLJSONAdapter modelsOfClass:[PIECashFlowModel class]
                                         fromJSONArray:dataDicts
                                                 error:nil];
                         if (block != nil)
                         {
                             block(retArray);
                         }
                     }
                   }];
}

@end
