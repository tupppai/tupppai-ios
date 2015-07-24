//
//  ATOMRecordModel.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/21/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMRecordModel : NSObject
+ (void)record :(NSDictionary*)param withBlock:(void (^)(NSError *,NSString*))block ;
@end
