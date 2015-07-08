//
//  ATOMReportModel.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/6/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMReportModel : NSObject
+ (NSURLSessionDataTask *)report :(NSDictionary*)param withBlock:(void (^)(NSError *))block;
@end
