//
//  PIEChannelManager.m
//  TUPAI
//
//  Created by chenpeiwei on 12/9/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelManager.h"
#import "PIEChannelViewModel.h"
#import "PIEModelImage.h"
#import "PIEChannelViewModel.h"
#import "PIEChannelTutorialModel.h"
@implementation PIEChannelManager
+ (void)getSource_Channel:(NSDictionary *)params
                    block:(void (^)(NSMutableArray<PIEChannelViewModel *> *))block {
    [DDBaseService GET:params
                   url:URL_ChannelHomeThreads
                 block:^(id responseObject) {
                     

                     if (responseObject) {
                         NSMutableArray* retArray = [NSMutableArray new];
                         NSArray* categories      = [responseObject objectForKey:@"data"];
                         
                         
                         for (NSDictionary* dic in categories) {
                             PIEChannelViewModel* vm = [PIEChannelViewModel new];
                             vm.ID         = [[dic objectForKey:@"id"]integerValue];
                             vm.imageUrl   = [dic objectForKey:@"app_pic"];
                             vm.post_btn   = [dic objectForKey:@"post_btn"];
                             vm.banner_pic = [dic objectForKey:@"banner_pic"];
                             vm.iconUrl    = [dic objectForKey:@"icon"];
                             vm.title      = [dic objectForKey:@"display_name"];
                             vm.content    = [dic objectForKey:@"description"];
                             vm.url        = [dic objectForKey:@"url"];
                             vm.askID      = [[dic objectForKey:@"ask_id"]integerValue];

                             NSString *category_type = [dic objectForKey:@"category_type"];
                             if ([category_type isEqualToString:@"activity"]) {
                                 vm.channelType = PIEChannelTypeActivity;
                             }
                             else if ([category_type isEqualToString:@"channel"])
                             {
                                 vm.channelType = PIEChannelTypeChannel;
                             }
                             else if ([category_type isEqualToString:@"tutorial"])
                             {
                                 vm.channelType = PIEChannelTypeTutorial;
                             }
                             
                             
                             NSMutableArray* threads_transformed = [NSMutableArray new];
                             NSArray* threads = [dic objectForKey:@"threads"];
                             for (NSDictionary*dic in threads) {
                                 //entity就是model
                                 PIEPageModel *entity = [MTLJSONAdapter modelOfClass:[PIEPageModel class] fromJSONDictionary:dic error:NULL];
                                 PIEPageVM* vm = [[PIEPageVM alloc]initWithPageEntity:entity];
                                 [threads_transformed addObject:vm];
                             }
                             vm.threads = threads_transformed;
                             [retArray addObject:vm];
                         }
                         
                         if (block) {
                             block(retArray);
                         }
                     } else {
                         if (block) {
                             block(nil);
                         }
                     }
                 }];
}

+ (void)getSource_channelPages:(NSDictionary *)params
                     resultBlock:(void (^)
                                  (NSMutableArray<PIEPageVM *>
                                   *pageArray))resultBlock
                      completion:(void (^)(void))completionBlock
{
    [DDBaseService GET:params
                   url:@"category/threads"
                 block:^(id responseObject) {
                     if (responseObject != nil)
                     {
                         
                         NSMutableArray <PIEPageVM *> *retArray = [NSMutableArray array];
                         NSArray *dataArray                 = responseObject[@"data"];
                         
                         // Dictionary -> Model -> ViewModel
                         for (NSDictionary *dict in dataArray) {
                             
                             PIEPageModel *entity = [MTLJSONAdapter modelOfClass:[PIEPageModel class] fromJSONDictionary:dict error:NULL];
                             
                             PIEPageVM *vm = [[PIEPageVM alloc] initWithPageEntity:entity];
                             
                             [retArray addObject:vm];
                         }

                         if (resultBlock != nil) {
                             resultBlock(retArray);
                         }
                         
                         if (completionBlock != nil) {
                             completionBlock();
                         }
                     }
                 }];
}

+ (void)getSource_channelTutorialList:(NSDictionary *)params
                                block:(void (^)(NSArray<PIEChannelTutorialModel *> *))block
                         failureBlock:(void (^)(void))failure{
    [DDBaseService GET:params
                   url:@"thread/tutorials_list"
                 block:^(id responseObject) {
                     if (responseObject == nil) {
                         if (failure != nil) {
                             failure();
                         }
                     }
                     else{
                         NSArray<PIEChannelTutorialModel *> *retArray =
                         [NSArray<PIEChannelTutorialModel *> array];
                         NSDictionary *dataDict = responseObject[@"data"];
                         NSArray<NSDictionary *> *tutorials = dataDict[@"tutorials"];
                         retArray =
                         [MTLJSONAdapter modelsOfClass:[PIEChannelTutorialModel class]
                                         fromJSONArray:tutorials
                                                 error:nil];
                         if (block != nil) {
                             block(retArray);
                         }
                     }
                 }];
}

@end
