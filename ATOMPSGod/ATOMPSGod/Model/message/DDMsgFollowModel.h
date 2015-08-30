//
//  ATOMShowConcernMessage.h
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDMsgFollowModel : NSObject

+ (void)getFollowMsg:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block ;
@end
