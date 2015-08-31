//
//  ATOMShowProceeding.h
//  ATOMPSGod
//
//  Created by atom on 15/4/7.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDMyProceedingManager : NSObject
+ (void)getMyProceeding:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block;
@end
