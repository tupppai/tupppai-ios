//
//  PIEChannelDetailAskPSItemView.m
//  TUPAI
//
//  Created by huangwei on 15/12/9.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelDetailAskPSItemView.h"

@implementation PIEChannelDetailAskPSItemView
-(void)awakeFromNib {
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
}
@end
