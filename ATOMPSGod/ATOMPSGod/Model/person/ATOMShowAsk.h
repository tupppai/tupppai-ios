//
//  ATOMShowAsk.h
//  ATOMPSGod
//
//  Created by atom on 15/4/7.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMShowAsk : NSObject

- (NSURLSessionDataTask *)ShowMyAsk:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *resultArray, NSError *error))block;

@end
