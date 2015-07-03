//
//  ATOMCollectModel.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/2/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMCollectModel : NSObject
+ (NSURLSessionDataTask *)toggleCollect:(NSDictionary *)param withPageType:(ATOMPageType)type withID:(NSInteger)ID withBlock:(void (^)(NSError *))block;
@end
