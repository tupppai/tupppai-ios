//
//  ATOMImageTipLabelViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/3/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDTipLabelVM.h"
#import "ATOMImageTipLabel.h"

@implementation DDTipLabelVM

- (void)setViewModelData:(ATOMImageTipLabel *)tipLabel {
    _x = tipLabel.x;
    _y = tipLabel.y;
    _content = tipLabel.content;
    _labelDirection = tipLabel.labelDirection;
}

- (CGRect)getFrame:(CGSize)imageSize {
    NSDictionary * attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.f], NSFontAttributeName, nil];
    CGSize actualSize = [_content boundingRectWithSize:CGSizeMake(MAXFLOAT, 13) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributeDic context:NULL].size;
    //小圆点在左边
    CGRect rect;
    if (_labelDirection == 0) {
        rect = CGRectMake(imageSize.width * _x, imageSize.height * _y - 30/2, actualSize.width + 40, 30);
    } else if (_labelDirection ==1) {
        rect = CGRectMake(imageSize.width * _x - actualSize.width - 40, imageSize.height * _y - 30/2 ,actualSize.width + 40, 30);
        NSLog(@"%@ , %f ,%f",_content,imageSize.width ,_x);
    }
    return rect;
}

@end
