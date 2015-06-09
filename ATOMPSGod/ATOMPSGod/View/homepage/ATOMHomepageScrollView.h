//
//  ATOMHomepageScrollView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWHomePageTableView.h"
#import "ATOMNoDataView.h"

typedef enum {
    ATOMHomepageHotType = 0,
    ATOMHomepageRecentType
}ATOMHomepageViewType;

@interface ATOMHomepageScrollView : UIScrollView
@property (nonatomic, strong) PWHomePageTableView *homepageHotTableView;
@property (nonatomic, strong) PWHomePageTableView *homepageAskTableView;
@property (nonatomic, strong) UIView *homepageHotView;
@property (nonatomic, strong) UIView *homepageRecentView;
@property (nonatomic, assign) ATOMHomepageViewType currentHomepageType;
- (void)changeUIAccording:(NSString *)buttonTitle;
- (NSInteger)typeOfCurrentHomepageView;
@end
