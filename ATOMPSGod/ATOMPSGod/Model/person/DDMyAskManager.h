//
//  ATOMShowMyAsk.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/9/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDMyAskManager : NSObject
+ (void)getMyAsk:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *dataArray))block;
@end
