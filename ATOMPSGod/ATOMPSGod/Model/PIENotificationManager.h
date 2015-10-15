//
//  PIENotificationManager.h
//  TUPAI
//
//  Created by chenpeiwei on 10/14/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIENotificationManager : NSObject
+ (void)getNotifications:(NSDictionary *)param block:(void (^)(NSArray *))block;
@end
