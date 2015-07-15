//
//  ATOMShareSDKModel.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/15/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMShareSDKModel : NSObject
+ (void)getUserInfo:(ShareType)type withBlock:(void (^)(NSDictionary* sourceData))block;
@end
