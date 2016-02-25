//
//  PIEChannelTutorialLockedUpView.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/26/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialLockedUpView.h"



@implementation PIEChannelTutorialLockedUpView

+ (PIEChannelTutorialLockedUpView *)lockedUpView
{
    return [[[NSBundle mainBundle]
             loadNibNamed:@"PIEChannelTutorialLockedUpView"
             owner:nil options:nil] lastObject];
}

@end
