//
//  ATOMOtherPersonView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"
@class ATOMOtherPersonCollectionHeaderView;

typedef enum {
    ATOMUploadType = 0,
    ATOMWorkType
}ATOMOtherPersonCollectionViewType;

@interface ATOMOtherPersonView : ATOMBaseView

@property (nonatomic, strong) ATOMOtherPersonCollectionHeaderView *uploadHeaderView;
@property (nonatomic, strong) ATOMOtherPersonCollectionHeaderView *workHeaderView;
@property (nonatomic, strong) UICollectionView *otherPersonUploadCollectionView;
@property (nonatomic, strong) UICollectionView *otherPersonWorkCollectionView;


- (void)changeToUploadView;
- (void)changeToWorkView;
- (ATOMOtherPersonCollectionViewType)typeOfCurrentCollectionView;


@end
