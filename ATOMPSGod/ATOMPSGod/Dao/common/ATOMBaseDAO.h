//
//  ATOMBaseDAO.h
//  ATOMPSGod
//
//  Created by atom on 15/3/17.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMBaseDAO : NSObject

@property (nonatomic,copy) NSString *dbPath;
@property (nonatomic,strong) FMDatabaseQueue *fmQueue;

@end
