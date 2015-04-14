//
//  ATOMAtComment.h
//  ATOMPSGod
//
//  Created by atom on 15/3/31.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseModel.h"

@interface ATOMAtComment : ATOMBaseModel;

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *content;

@end
