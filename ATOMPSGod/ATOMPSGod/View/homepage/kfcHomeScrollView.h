//
//  kfcHomeScrollView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableView.h"
#import "PIERefreshCollectionView.h"

@interface kfcHomeScrollView : UIScrollView
@property (nonatomic, strong) RefreshTableView *replyTable;
@property (nonatomic, strong) PIERefreshCollectionView *collectionView;
@property (nonatomic, assign) PIEHomeType type;
- (void)toggle;
- (void)toggleWithType:(PIEHomeType)type;
@end



