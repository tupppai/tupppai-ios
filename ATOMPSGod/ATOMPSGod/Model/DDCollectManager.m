//
//  ATOMCollectModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/2/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "DDCollectManager.h"
#import "DDSessionManager.h"

@implementation DDCollectManager
+ (void)toggleCollect:(NSDictionary *)param withPageType:(PIEPageType)type withID:(NSInteger)ID withBlock:(void (^)(NSError *))block {
        NSString* url;
        if (type == PIEPageTypeAsk) {
            url = [NSString stringWithFormat:@"ask/focusask/%zd",ID];
        }   if (type == PIEPageTypeReply) {
            url = [NSString stringWithFormat:@"reply/collectreply/%zd",ID];
        }
    
    [DDBaseService GET:param url:url block:^(id responseObject) {
        if (responseObject) {
            if (block) {
                block(nil);
            }
        }
    }];
}
@end
