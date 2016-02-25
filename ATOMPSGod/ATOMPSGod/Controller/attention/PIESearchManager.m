//
//  PIESearchManager.m
//  TUPAI
//
//  Created by chenpeiwei on 11/3/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIESearchManager.h"
#import "PIEUserModel.h"
#import "PIEUserViewModel.h"
@implementation PIESearchManager
+ (void)getSearchUserResult:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block {
    [DDService ddGetSearchUserResult:param withBlock:^(NSArray* data) {
        NSMutableArray* retArray = [NSMutableArray new];
        for (int i = 0; i<data.count; i++) {
            PIEUserModel *entity = [MTLJSONAdapter modelOfClass:[PIEUserModel class] fromJSONDictionary:data[i] error:NULL];
            PIEUserViewModel* vm = [[PIEUserViewModel alloc]initWithEntity:entity];
            
           NSArray* replies = [data[i]objectForKey:@"replies"];

            for (NSDictionary* dic in replies) {
                PIEPageModel *entity2 = [MTLJSONAdapter modelOfClass:[PIEPageModel class] fromJSONDictionary:dic error:NULL];
                PIEPageVM* vm2 = [[PIEPageVM alloc]initWithPageEntity:entity2];
                [vm.replyPages addObject:vm2];
            }
            [retArray addObject:vm];
        }
        if (block) {
            block(retArray);
        }
    }];
}

+ (void)getSearchContentResult:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block {
    [DDService ddGetSearchContentResult:param withBlock:^(NSArray* data) {
        NSMutableArray* retArray = [NSMutableArray new];

        for (NSDictionary* dic in data) {
            PIEPageModel *entity = [MTLJSONAdapter modelOfClass:[PIEPageModel class] fromJSONDictionary:dic error:NULL];
            PIEPageVM* vm = [[PIEPageVM alloc]initWithPageEntity:entity];
            [retArray addObject:vm];
        }
        if (block) {
            block(retArray);
        }
    }];
}
@end
