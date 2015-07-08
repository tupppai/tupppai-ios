//
//  ATOMOtherPersonView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"
#import "ATOMPersonPageScrollView.h"
@class ATOMOtherPersonCollectionHeaderView;



@interface ATOMOtherPersonView : ATOMBaseView
@property (nonatomic, strong) ATOMOtherPersonCollectionHeaderView *uploadHeaderView;
@property (nonatomic, strong) ATOMPersonPageScrollView *scrollView;

@end
