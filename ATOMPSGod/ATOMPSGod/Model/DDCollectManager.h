//
//  ATOMCollectModel.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/2/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDCollectManager : NSObject
+ (void)toggleCollect:(NSDictionary *)param withPageType:(PIEPageType)type withID:(NSInteger)ID withBlock:(void (^)(NSError *))block;
@end
