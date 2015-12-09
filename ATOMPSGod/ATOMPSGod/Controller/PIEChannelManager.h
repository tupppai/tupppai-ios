//
//  PIEChannelManager.h
//  TUPAI
//
//  Created by chenpeiwei on 12/9/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIEChannelManager : NSObject
+ (void)getSource_Channel:(NSDictionary *)param  block:(void (^)(NSMutableArray *))block;
@end

