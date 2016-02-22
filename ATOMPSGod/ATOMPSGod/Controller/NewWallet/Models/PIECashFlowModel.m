//
//  PIECashFlowModel.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/16/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIECashFlowModel.h"

@implementation PIECashFlowModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"cashFlowId":@"id",
             @"payerId":@"uid",
             @"balance":@"balance",
             @"avatarUrl":@"avatar",
             @"cashFlowModelType":@"type",
             @"amount":@"amount",
             @"paymentDesc":@"memo",
             @"paymentCreatedTime":@"created_at"};
}

+ (NSValueTransformer *)cashFlowModelTypeJSONTransformer{
    return
    [NSValueTransformer
     mtl_valueMappingTransformerWithDictionary:@{@"1":@(PIECashFlowModelTypeIncome),
                                                 @"2":@(PIECashFlowModelTypeOutcome)}];
}



@end
