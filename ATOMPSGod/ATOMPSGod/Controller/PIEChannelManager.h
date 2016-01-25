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
@end

