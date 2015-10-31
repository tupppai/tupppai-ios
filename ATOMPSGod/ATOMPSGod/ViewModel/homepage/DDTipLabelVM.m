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

//- (void)setViewModelData:(ATOMImageTipLabel *)tipLabel {
//    _x = tipLabel.x;
//    _y = tipLabel.y;
//    _content = tipLabel.content;
//    _labelDirection = tipLabel.labelDirection;
//}
//
//- (CGRect)getFrame:(CGSize)imageSize {
//    NSDictionary * attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.f], NSFontAttributeName, nil];
//    CGSize actualSize = [_content boundingRectWithSize:CGSizeMake(MAXFLOAT, 13) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributeDic context:NULL].size;
//    //小圆点在左边
//    CGRect rect;
//    CGFloat x,y,width,height;
//    
//    if (_labelDirection == 0) {
//        x = imageSize.width * _x;
//        y = imageSize.height * _y - 30/2;
//        width = actualSize.width + 40;
//        height = 30;
//        rect = CGRectMake(imageSize.width * _x, imageSize.height * _y - 30/2, actualSize.width + 40, 30);
//        if (x+width>imageSize.width) {
//            rect.origin.x = imageSize.width - width;
//        }
//    } else if (_labelDirection ==1) {
//        x = imageSize.width * _x;
//        y = imageSize.height * _y - 30/2;
//        width = actualSize.width + 40;
//        height = 30;
//        rect = CGRectMake(imageSize.width * _x - actualSize.width - 40, imageSize.height * _y - 30/2 ,actualSize.width + 40, 30);
//        
//        if (x-width<0) {
//            rect.origin.x = 0;
//        }
//    }
//    return rect;
//}

@end
