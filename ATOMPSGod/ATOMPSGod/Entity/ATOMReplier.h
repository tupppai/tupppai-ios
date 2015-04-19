//
//  ATOMReplier.h
//  ATOMPSGod
//
//  Created by atom on 15/4/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseModel.h"

@interface ATOMReplier : ATOMBaseModel <MTLFMDBSerializing>

@property (nonatomic, assign) NSInteger replierID;
@property (nonatomic, assign) NSInteger imageID;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;

@end
