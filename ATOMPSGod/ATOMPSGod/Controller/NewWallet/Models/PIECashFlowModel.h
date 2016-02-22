//
//  PIECashFlowModel.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/16/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEBaseModel.h"

typedef NS_ENUM(NSUInteger, PIECashFlowModelType) {
    PIECashFlowModelTypeIncome,
    PIECashFlowModelTypeOutcome
};

@interface PIECashFlowModel : PIEBaseModel

@property (nonatomic, assign) NSInteger cashFlowId;

@property (nonatomic, assign) NSInteger payerId;

@property (nonatomic, copy)   NSString  *avatarUrl;

@property (nonatomic, assign) double balance;

@property (nonatomic, assign) PIECashFlowModelType cashFlowModelType;

@property (nonatomic, assign) double amount;

@property (nonatomic, copy)   NSString *paymentDesc;

@property (nonatomic, copy)   NSString *paymentCreatedTime;

@end
