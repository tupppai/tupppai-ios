//
//  PIEChannelManager.m
//  TUPAI
//
//  Created by chenpeiwei on 12/9/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelManager.h"
#import "PIEChannelViewModel.h"
@implementation PIEChannelManager
+ (void)getSource_Channel:(NSDictionary *)params  block:(void (^)(NSMutableArray *))block {
    [DDBaseService GET:params
                   url:URL_ChannelHomeThreads
                 block:^(id responseObject) {
                     if (responseObject) {
                         NSMutableArray* retArray = [NSMutableArray new];
                         NSDictionary* data = [responseObject objectForKey:@"data"];
                         NSArray* categories = [data objectForKey:@"categories"];
                         
                         
                         for (NSDictionary* dic in categories) {
                             PIEChannelViewModel* vm = [PIEChannelViewModel new];
                             vm.ID = [[dic objectForKey:@"id"]integerValue];
                             vm.imageUrl = [dic objectForKey:@"app_pic"];
                             vm.iconUrl = [dic objectForKey:@"icon"];
                             vm.title = [dic objectForKey:@"display_name"];
                             vm.content = [dic objectForKey:@"description"];
                             
                             NSMutableArray* threads_transformed = [NSMutableArray new];
                             NSArray* threads = [dic objectForKey:@"threads"];
                             for (NSDictionary*dic in threads) {
                                 //entity就是model
                                 PIEPageEntity *entity = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:dic error:NULL];
                                 [threads_transformed addObject:entity];
                             }
                             vm.threads = threads_transformed;
                             [retArray addObject:vm];
                         }
                         
                         
                         if (block) {
                             block(retArray);
                         }
                     }
                 }];
}


@end
