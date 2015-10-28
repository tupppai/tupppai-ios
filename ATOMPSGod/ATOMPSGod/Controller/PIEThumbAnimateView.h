//
//  PIEThumbAnimateView2.h
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/14/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

typedef NS_ENUM(NSInteger, PIEAnimateViewType) {
    PIEAnimateViewTypeLeft,
    PIEAnimateViewTypeRight
};
@interface PIEThumbAnimateView : UIView
@property (nonatomic,assign)  NSInteger subviewCounts;
@property (nonatomic,assign)  BOOL toExpand;
@property (strong, nonatomic)  UIImageView *blurView;
@property (strong, nonatomic)  UIImageView *originView;
@property (strong, nonatomic)  UIImageView *leftView;
@property (strong, nonatomic)  UIImageView *rightView;

@end
