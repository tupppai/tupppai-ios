//
//  kfcHomeScrollView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIERefreshTableView.h"
#import "PIERefreshCollectionView.h"
#import "SwipeView.h"
typedef NS_ENUM(NSInteger, PIENewScrollType) {
    PIENewScrollTypeAsk = 1,
    PIENewScrollTypeReply ,
    PIENewScrollTypeActivity
};

@interface PIENewScrollView : UIScrollView
@property (nonatomic, strong) PIERefreshTableView *tableReply;
@property (nonatomic, strong) PIERefreshCollectionView *collectionViewAsk;
@property (nonatomic, strong) PIERefreshTableView *tableActivity;
@property (nonatomic, strong) SwipeView *swipeView;
@property (nonatomic, assign) PIENewScrollType type;
- (void)toggleWithType:(PIENewScrollType)type;
@end



