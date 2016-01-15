//
//  PIEProceedingToHelpHeaderView.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/15/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEProceedingToHelpHeaderView.h"

@implementation PIEProceedingToHelpHeaderView

+ (PIEProceedingToHelpHeaderView *)headerView{
    return [[[NSBundle mainBundle] loadNibNamed:@"PIEProceedingToHelpHeaderView"
                                         owner:nil options:nil] lastObject];
}

@end
