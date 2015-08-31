//
//  ATOMShowCollection.h
//  ATOMPSGod
//
//  Created by atom on 15/4/8.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDMyCollectionManager : NSObject

+ (void)getMyCollection:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *resultArray))block;

@end
