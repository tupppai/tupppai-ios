//
//  PIEChargeMoneyPanelView.m
//  TUPAI
//
//  Created by huangwei on 16/1/22.
//  Copyright © 2016年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChargeMoneyPanelView.h"

@implementation PIEChargeMoneyPanelView

+ (PIEChargeMoneyPanelView *)chargeMoneyPanel
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PIEChargeMoneyPanelView"
                                         owner:nil options:nil] lastObject];
}

@end
