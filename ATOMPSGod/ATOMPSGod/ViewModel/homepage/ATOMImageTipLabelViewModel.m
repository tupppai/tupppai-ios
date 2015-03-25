//
//  ATOMImageTipLabelViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/3/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMImageTipLabelViewModel.h"
#import "ATOMImageTipLabel.h"

@implementation ATOMImageTipLabelViewModel

- (void)setViewModelData:(ATOMImageTipLabel *)tipLabel {
    _x = tipLabel.x;
    _y = tipLabel.y;
    _content = tipLabel.content;
    _labelDirection = tipLabel.labelDirection;
}

- (CGRect)imageTipLabelFrameByImageSize:(CGSize)imageSize {
    NSDictionary * attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.f], NSFontAttributeName, nil];
    CGSize actualSize = [_content boundingRectWithSize:CGSizeMake(MAXFLOAT, 13) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributeDic context:NULL].size;
    //小圆点在左边
    CGRect rect;
    rect = CGRectMake(imageSize.width * _x, imageSize.height * _y, actualSize.width + 40, 30);
    return rect;
}

@end
