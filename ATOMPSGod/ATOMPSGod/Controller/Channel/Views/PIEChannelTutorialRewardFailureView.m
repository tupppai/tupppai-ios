//
//  PIEChannelTutorialRewardFailureView.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/25/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialRewardFailureView.h"

@implementation PIEChannelTutorialRewardFailureView

+ (PIEChannelTutorialRewardFailureView *)rewardFailureView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PIEChannelTutorialRewardFailureView"
                                          owner:nil options:nil] lastObject];
}

@end
