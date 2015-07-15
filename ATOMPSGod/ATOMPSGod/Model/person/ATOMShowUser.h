//
//  ATOMShowUser.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/15/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMShowUser : NSObject
+ (NSURLSessionDataTask *)ShowUserInfo:(void (^)(ATOMUser *, NSError *))block;
@end
