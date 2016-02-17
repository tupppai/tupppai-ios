//
//  PIEProceedingToHelpHeaderView_undone.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/5/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEProceedingToHelpHeaderView_undone.h"

@implementation PIEProceedingToHelpHeaderView_undone

+ (PIEProceedingToHelpHeaderView_undone *)headerView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PIEProceedingToHelpHeaderView_undone"
                                          owner:nil options:nil] lastObject];
}

@end
