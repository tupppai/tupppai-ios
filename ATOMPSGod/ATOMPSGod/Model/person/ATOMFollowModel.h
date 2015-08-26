//
//  ATOMFollowModel.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/9/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMFollowModel : NSObject
+ (NSURLSessionDataTask *)follow :(NSDictionary*)param withBlock:(void (^)(NSError *))block;
@end
