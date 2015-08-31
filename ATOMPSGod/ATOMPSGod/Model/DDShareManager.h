//
//  ATOMShareModel.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/26/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATOMShare.h"

@interface DDShareManager : NSObject
- (NSURLSessionDataTask *)getShareInfo:(NSDictionary *)param withBlock:(void (^)(ATOMShare *, NSError *))block;
@end
