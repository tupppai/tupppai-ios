//
//  PIEChannelManager.h
//  TUPAI
//
//  Created by chenpeiwei on 12/9/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PIEChannelViewModel;
@class PIEPageVM;
@interface PIEChannelManager : NSObject

+ (void)getSource_Channel:(NSDictionary *)params
                    block:(void (^)(NSMutableArray<PIEChannelViewModel *> *))block;

+ (void)getSource_pageViewModels:(NSDictionary *)params
                     resultBlock:(void (^)(NSMutableArray<PIEPageVM *>
                                           *latestAskForPSResultArray,
                                           NSMutableArray<PIEPageVM *>
                                           *usersRepliesResultArray))resultBlock
                      completion:(void (^)(void))completionBlock;

+ (void)getSource_pageViewModels:(NSDictionary *)params
                   repliesResult:(void (^)
                                  (NSMutableArray<PIEPageVM *> * repliesResultArray ,PIEChannelViewModel *vm))repliesResultBlock;
@end

