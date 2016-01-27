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
@class PIEChannelTutorialModel;

@interface PIEChannelManager : NSObject

+ (void)getSource_Channel:(NSDictionary *)params
                    block:(void (^)(NSMutableArray<PIEChannelViewModel *> *))block;

+ (void)getSource_channelPages:(NSDictionary *)params
                   resultBlock:(void (^)
                                (NSMutableArray<PIEPageVM *>
                                 *pageArray))resultBlock
                    completion:(void (^)(void))completionBlock;



+ (void)getSource_channelTutorialList:(NSDictionary *)params
                                block:(void (^)(NSArray<PIEChannelTutorialModel *> *retArray))block
                         failureBlock:(void (^)(void))failure;

+ (void)getSource_channelTutorialDetail:(NSDictionary *)params
                                  block:(void(^)(PIEChannelTutorialModel *model))block
                           failureBlock:(void (^)(void))failure;

/*
    TODO: rollDiceReward的处理未知，先在外面写好了之后再refactor
 */
//+ (void)rollDiceReward:(NSDictionary *)params

@end

