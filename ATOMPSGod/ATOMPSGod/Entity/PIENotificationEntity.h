//
//  PIENotificationEntity.h
//  TUPAI
//
//  Created by chenpeiwei on 10/14/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "ATOMBaseModel.h"

@interface PIENotificationEntity : ATOMBaseModel
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) long long createTime;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger commentType;
@end
