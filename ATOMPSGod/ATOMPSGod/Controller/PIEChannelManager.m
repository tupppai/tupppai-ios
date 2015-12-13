//
//  PIEChannelManager.m
//  TUPAI
//
//  Created by chenpeiwei on 12/9/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelManager.h"
#import "PIEChannelViewModel.h"
#import "PIEImageEntity.h"
@implementation PIEChannelManager
+ (void)getSource_Channel:(NSDictionary *)params
                    block:(void (^)(NSMutableArray<PIEChannelViewModel *> *))block {
    [DDBaseService GET:params
                   url:URL_ChannelHomeThreads
                 block:^(id responseObject) {
                     
                     
                     if (responseObject) {
                         NSMutableArray* retArray = [NSMutableArray new];
                         NSDictionary* data       = [responseObject objectForKey:@"data"];
                         NSArray* categories      = [data objectForKey:@"categories"];
                         
                         
                         for (NSDictionary* dic in categories) {
                             PIEChannelViewModel* vm = [PIEChannelViewModel new];
                             vm.ID         = [[dic objectForKey:@"id"]integerValue];
                             vm.imageUrl   = [dic objectForKey:@"app_pic"];
                             vm.post_btn   = [dic objectForKey:@"post_btn"];
                             vm.banner_pic = [dic objectForKey:@"banner_pic"];
                             vm.iconUrl    = [dic objectForKey:@"icon"];
                             vm.title      = [dic objectForKey:@"display_name"];
                             vm.content    = [dic objectForKey:@"description"];
                             
                             NSString *category_type = [dic objectForKey:@"category_type"];
                             if ([category_type isEqualToString:@"activity"]) {
                                 vm.channelType = PIEChannelTypeActivity;
                             }
                             else if ([category_type isEqualToString:@"channel"])
                             {
                                 vm.channelType = PIEChannelTypeChannel;
                             }
                             
                             
                             NSMutableArray* threads_transformed = [NSMutableArray new];
                             NSArray* threads = [dic objectForKey:@"threads"];
                             for (NSDictionary*dic in threads) {
                                 //entity就是model
                                 PIEPageEntity *entity = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:dic error:NULL];
                                 PIEPageVM* vm = [[PIEPageVM alloc]initWithPageEntity:entity];
                                 [threads_transformed addObject:vm];
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



+ (void)getSource_pageViewModels:(NSDictionary *)params
                     resultBlock:(void (^)
                                  (NSMutableArray<PIEPageVM *>
                                   *latestAskForPSResultArray,
                                   NSMutableArray<PIEPageVM *>
                                   *usersRepliesResultArray))resultBlock
                      completion:(void (^)(void))completionBlock
{
    [DDBaseService GET:params
                   url:URL_ChannelGetDetailThreads
                 block:^(id responseObject) {
                     if (responseObject != nil)
                     {
                         NSMutableArray<PIEPageVM *> *latestAskForPSResultArray
                         = nil;
                         
                         NSMutableArray<PIEPageVM *> *usersRepliesResultArray = nil;
                         
                         latestAskForPSResultArray =
                         [self
                          pageViewModelsWithResponseObject:responseObject
                          ColumnName:@"ask"];
                         
                         usersRepliesResultArray =
                         [self
                          pageViewModelsWithResponseObject:responseObject
                          ColumnName:@"replies"];
                         
                         if (resultBlock != nil) {
                             resultBlock(latestAskForPSResultArray, usersRepliesResultArray);
                         }
                         
                         if (completionBlock != nil) {
                             completionBlock();
                         }
                     }
                 }];
}

+ (void)getSource_pageViewModels:(NSDictionary *)params
                   repliesResult:(void (^)
                                  (NSMutableArray<PIEPageVM *> * repliesResultArray))repliesResultBlock
{
    [DDBaseService GET:params
                   url:URL_ChannelActivity
                 block:^(id responseObject) {
                     NSMutableArray<PIEPageVM *> *repliesResultArray = nil;
                     
                     // 暂付阙疑
                     repliesResultArray =
                     [self pageViewModelsWithResponseObject:responseObject ColumnName:@"replies"];
                     
                     if (repliesResultBlock != nil) {
                         repliesResultBlock(repliesResultArray);
                     }
                     
                 }];
}

#pragma mark - private helpers

/**
 *  NSDictionary, NSString -> NSArray<PIEPageVM *>;
    解析JSON数据为PIEPageVM对象数组
 *
 *  @param columnName     JSON的字段名
 *
 */
+ (NSMutableArray <PIEPageVM *> *)
pageViewModelsWithResponseObject:(NSDictionary *)responseObject
                      ColumnName:(NSString *)columnName
{
    NSMutableArray <PIEPageVM *> *retArray = [NSMutableArray array];
    NSDictionary *dataDict                 = responseObject[@"data"];
    NSArray *pageVMDicts                   = dataDict[columnName];
    
    // Dictionary -> Model -> ViewModel
    for (NSDictionary *dict in pageVMDicts) {
        
        PIEPageEntity *entity = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:dict error:NULL];
        
        /*
            TODO: TO-BE-REFACTORED
            NSMutableArray<NSDictionary *> -> NSMutableArray<PIEImageEntity *>, 
            然后再让前者的指针指向后者（是否会出现类型冲突？或者是歧义？）
         */
        NSMutableArray *thumbArray = [NSMutableArray array];
        for (NSDictionary *imageEntityDict in entity.thumbEntityArray) {
            PIEImageEntity *imageEntity =
            [MTLJSONAdapter modelOfClass:[PIEImageEntity class]
                      fromJSONDictionary:imageEntityDict
                                   error:nil];
            [thumbArray addObject:imageEntity];
        }
        entity.thumbEntityArray = thumbArray;
        
        PIEPageVM *vm = [[PIEPageVM alloc] initWithPageEntity:entity];
        
        [retArray addObject:vm];
    }
    
    return retArray;
}

@end
