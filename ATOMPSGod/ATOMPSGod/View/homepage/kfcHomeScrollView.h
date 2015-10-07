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

typedef NS_ENUM(NSInteger, PIENewScrollType) {
    PIENewScrollTypeAsk = 1,
    PIENewScrollTypeReply = 2
};

@interface kfcHomeScrollView : UIScrollView
@property (nonatomic, strong) RefreshTableView *replyTable;
@property (nonatomic, strong) PIERefreshCollectionView *collectionView;
@property (nonatomic, assign) PIENewScrollType type;
- (void)toggle;
- (void)toggleWithType:(PIENewScrollType)type;
- (void)toggleType;
@end



