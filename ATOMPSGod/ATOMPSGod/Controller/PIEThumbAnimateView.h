//
//  PIEThumbAnimateView2.h
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/14/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIEThumbAnimateView : UIView
@property (nonatomic,assign)  NSInteger subviewCounts;
@property (nonatomic,assign)  BOOL toExpand;
@property (nonatomic,assign)  CGSize expandedSize;
@property (nonatomic,assign)  CGSize shrinkedSize;
@property (strong, nonatomic)  UIImageView *originView;
@property (strong, nonatomic)  UIImageView *leftView;
@property (strong, nonatomic)  UIImageView *rightView;

@end
