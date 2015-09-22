//
//  PIEAskImageDao.h
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/22/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATOMBaseDAO.h"
#import "PIEImageEntity.h"

@interface PIEAskImageDao : ATOMBaseDAO

+ (void)insert:(PIEImageEntity *)entity;
+ (void)update:(PIEImageEntity *)entity;
+ (NSMutableArray *)selectByID:(NSInteger)ID;
+ (BOOL)isExist:(PIEImageEntity *)entity;
+ (void)clear;

@end
