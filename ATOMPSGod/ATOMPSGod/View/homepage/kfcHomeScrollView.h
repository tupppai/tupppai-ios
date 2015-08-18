//
//  kfcHomeScrollView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableView.h"


@interface kfcHomeScrollView : UIScrollView
@property (nonatomic, strong) RefreshTableView *hotTable;
@property (nonatomic, strong) RefreshTableView *askTable;
@property (nonatomic, strong) UIView *homepageHotView;
@property (nonatomic, strong) UIView *homepageRecentView;
@property (nonatomic, assign) ATOMHomepageViewType currentHomepageType;
- (void)changeUIAccording:(NSString *)buttonTitle;
- (NSInteger)typeOfCurrentHomepageView;
@end
