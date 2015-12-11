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
                         NSDictionary* data       = [responseObject objectForKey:@"data"];
                         NSArray* categories      = [data objectForKey:@"categories"];
                         
                         
                         for (NSDictionary* dic in categories) {
                             PIEChannelViewModel* vm = [PIEChannelViewModel new];
                             vm.ID       = [[dic objectForKey:@"id"]integerValue];
                             vm.imageUrl = [dic objectForKey:@"app_pic"];
                             vm.iconUrl  = [dic objectForKey:@"icon"];
                             vm.title    = [dic objectForKey:@"display_name"];
                             vm.content  = [dic objectForKey:@"description"];
                             
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
                         NSLog(@"source: %@, source.count: %zd", retArray, retArray.count);
                         
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
     返回
     code = 0;
     data =     {
        ask =         (
     );
        replies =         (
     );
     };
     data字段里面的ask: 最新求P
     */
    
    [DDBaseService GET:params
                   url:URL_ChannelLatestAskForPS
                 block:^(id responseObject) {
                     if (responseObject != nil) {
                         NSMutableArray<PIEPageVM *> *retArray = nil;
                         retArray =
                         [self pageViewModelsWithResponseObject:responseObject
                                                     ColumnName:@"ask"];
                         if (block != nil) {
                             block(retArray);
                         }
                     }
                 }];
}

+ (void)getSource_usersPSByChannelID:(NSDictionary *)params
                               block:(void (^)(NSMutableArray<PIEPageVM *> *resultArray))block
{
    
    /*
     /thread/get_threads_by_channel
     URL_ChannelUsersPS
     返回
     code = 0;
     data =     {
        ask =         (
     );
        replies =         (
     );
     };
     data字段里面的replies: 该频道的所有用户的PS作品
     */
    
    [DDBaseService GET:params
                   url:URL_ChannelUsersPS
                 block:^(id responseObject) {
                     if (responseObject){
                         NSMutableArray<PIEPageVM *> *retArray = nil;
                         retArray =
                         [self pageViewModelsWithResponseObject:responseObject
                                                     ColumnName:@"replies"];
                         if (block == nil) {
                             block(retArray);
                         }
                     }
                 }];
}

/**
 *  Fetch latestAskForArray & usersPSArray at the same time.
 *
 *  @param latestAskForPSBlock 返回latestAskForPS的viewModels
 *  @param usersPSBlock        返回usersPS的viewModels
 */
+ (void)getSource_pageViewModels:(NSDictionary *)params
             latestAskForPSBlock:(void (^)(NSMutableArray<PIEPageVM *> *latestAskForPSResultArray))latestAskForPSBlock
                    usersPSBlock:(void (^)(NSMutableArray<PIEPageVM *> *usersPSResultArray))usersPSBlock
                      completion:(void (^)(void))completionBlock
{
    [DDBaseService GET:params
                    url:URL_ChannelGetDetailThreads
                  block:^(id responseObject) {
                      if (responseObject != nil)
                      {
                          
                          NSMutableArray<PIEPageVM *> *latestAskForPSResultArray
                          = nil;
                          
                          NSMutableArray<PIEPageVM *> *usersPSResultArray = nil;
                          
                          latestAskForPSResultArray =
                          [self
                           pageViewModelsWithResponseObject:responseObject
                           ColumnName:@"ask"];
                          
                          usersPSResultArray =
                          [self
                           pageViewModelsWithResponseObject:responseObject
                           ColumnName:@"replies"];
                          
                          
                          if (latestAskForPSBlock != nil)
                          {
                              latestAskForPSBlock(latestAskForPSResultArray);
                          }
                          
                          if (usersPSBlock != nil)
                          {
                              usersPSBlock(usersPSResultArray);
                          }
                          
                          if (completionBlock != nil) {
                              completionBlock();
                          }
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
        
        PIEPageVM *vm = [[PIEPageVM alloc] initWithPageEntity:entity];
        
        [retArray addObject:vm];
    }
    
    return retArray;
}

@end
