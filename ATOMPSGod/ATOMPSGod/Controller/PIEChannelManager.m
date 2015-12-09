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
+ (void)getSource_Channel:(NSDictionary *)params
                    block:(void (^)(NSMutableArray<PIEChannelViewModel *> *))block {
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


+ (void)getSource_latestAskForPS:(NSDictionary *)params
                           block:(void (^)(NSMutableArray<PIEPageVM *> *resultArray))block
{
    
    /*
     /thread/get_threads_by_channel
     URL_ChannelLatestAskForPS
     接受参数
     get:
     channel_id: 频道id
     page:页面，默认为1
     size:页面数目，默认为10
     last_updated:最后下拉更新的时间戳（整数10位）
     
     返回
     
     code = 0;
     data =     {
        ask =         (
     );
        replies =         (
     );
     };
     debug = 1;
     info = "";
     ret = 1;
     token = feeb2e6fd5f5025921f97fae210f71ab3dfd9bf5;
     } ,error (null)
     
     data字段里面的ask: 最新求P
     
     */

    [DDBaseService GET:params
                   url:URL_ChannelLatestAskForPS
                 block:^(id responseObject) {
                     NSLog(@"\n\n\n\n\n\n\n\n\n");
                     NSLog(@"response: %@\n", responseObject);
                     block(nil);
                 }];
}

+ (void)getSource_usersPSByChannelID:(NSDictionary *)params
                               block:(void (^)(NSMutableArray<PIEPageVM *> *resultArray))block
{
    
    /*
     /thread/get_threads_by_channel
     URL_ChannelUsersPS
     
     接受参数
     get:
     channel_id: 频道id
     page:页面，默认为1
     size:页面数目，默认为10
     last_updated:最后下拉更新的时间戳（整数10位）
     
     返回
     
     code = 0;
     data =     {
        ask =         (
     );
        replies =         (
     );
     };
     debug = 1;
     info = "";
     ret = 1;
     token = feeb2e6fd5f5025921f97fae210f71ab3dfd9bf5;
     } ,error (null)
     
     data字段里面的replies: 该频道的所有用户的PS作品
     
     */
    
    [DDBaseService GET:params
                   url:URL_ChannelUsersPS
                 block:^(id responseObject) {
                     block(nil);
                 }];

}
@end
