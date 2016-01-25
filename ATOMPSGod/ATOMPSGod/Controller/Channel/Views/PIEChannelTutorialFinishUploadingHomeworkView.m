//
//  PIEChannelTutorialFinishUploadingHomeworkView.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/25/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialFinishUploadingHomeworkView.h"

@implementation PIEChannelTutorialFinishUploadingHomeworkView

+ (PIEChannelTutorialFinishUploadingHomeworkView *)finishUploadingHomeworkView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PIEChannelTutorialFinishUploadingHomeworkView"
                                          owner:nil options:nil] lastObject];
}

@end
