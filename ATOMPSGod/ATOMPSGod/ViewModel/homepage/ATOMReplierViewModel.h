//
//  ATOMReplierViewModel.h
//  ATOMPSGod
//
//  Created by atom on 15/4/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATOMReplier;

@interface ATOMReplierViewModel : NSObject

@property (nonatomic, copy) NSString *avatarURL;
- (void)setViewModelData:(ATOMReplier *)replier;

@end
