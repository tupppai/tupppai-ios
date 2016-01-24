//
//  PIEChooseChargeSourceActionSheet.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/24/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChooseChargeSourceActionSheet.h"

@implementation PIEChooseChargeSourceActionSheet

+ (PIEChooseChargeSourceActionSheet *)actionSheet
{
    return [[[NSBundle mainBundle]
             loadNibNamed:@"PIEChooseChargeSourceActionSheet"
             owner:nil options:nil] lastObject];
}

@end
