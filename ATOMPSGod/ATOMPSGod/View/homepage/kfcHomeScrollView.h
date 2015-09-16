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
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *homepageHotView;
@property (nonatomic, strong) UIView *homepageAskView;
@property (nonatomic, assign) ATOMHomepageViewType type;
- (void)changeUIAccording:(NSString *)buttonTitle;
@end
