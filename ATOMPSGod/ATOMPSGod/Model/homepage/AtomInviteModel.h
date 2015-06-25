//
//  AtomInviteModel.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/24/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AtomInviteModel : NSObject
- (AFHTTPRequestOperation *)showMasters:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block;
@end
