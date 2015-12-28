//
//  PIEEliteManager.h
//  TUPAI
//
//  Created by chenpeiwei on 9/29/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIEBannerModel.h"

//#import "PIEEliteEntity.h"
@interface PIEEliteManager : NSObject
+ (void)getMyFollow:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block;
+ (void)getHotPages:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block;
+ (void)getBannerSource:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block;
@end
