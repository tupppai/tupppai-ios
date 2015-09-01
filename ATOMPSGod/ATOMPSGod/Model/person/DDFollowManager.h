//
//  ATOMShowConcern.h
//  ATOMPSGod
//
//  Created by atom on 15/4/15.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DDFollowManager : NSObject
+ (void )getFollow:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *recommendArray, NSMutableArray *myFollowArray))block;
@end
