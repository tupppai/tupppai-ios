//
//  PIESearchManager.h
//  TUPAI
//
//  Created by chenpeiwei on 11/3/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIESearchManager : NSObject
+ (void)getSearchUserResult:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block ;
+ (void)getSearchContentResult:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block;
@end
