//
//  PIEMyWalletManager.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/16/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PIECashFlowModel;

@interface PIEMyWalletManager : NSObject

+ (void)transactionDetails:(NSDictionary *)params
                     block:(void (^)(NSArray<PIECashFlowModel *> *))block
                   failure:(void (^)(void))failureBlock;

@end
