//
//  PIEChannelTutorialHomeworkViewController.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/28/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "DDBaseVC.h"
@class PIEChannelTutorialModel;

@interface PIEChannelTutorialHomeworkViewController : DDBaseVC

@property (nonatomic, strong) PIEChannelTutorialModel *currentTutorialModel;

/** 用户第一次滑进这个tab的时候就自动开始刷新数据 */
- (void)refreshHeaderImmediately;

@end
