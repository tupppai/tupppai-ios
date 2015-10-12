//
//  PIEProceedingScrollView.h
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/18/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIERefreshCollectionView.h"
#import "RefreshTableView.h"

typedef NS_ENUM(NSInteger, PIEProceedingType) {
    PIEProceedingTypeAsk = 0,
    PIEProceedingTypeToHelp,
    PIEProceedingTypeDone
};
@interface PIEProceedingScrollView : UIScrollView
//@property (nonatomic, strong) PIERefreshCollectionView *askCollectionView;
@property (nonatomic, strong) RefreshTableView *askTableView;
@property (nonatomic, strong) RefreshTableView *toHelpTableView;
@property (nonatomic, strong) PIERefreshCollectionView *doneCollectionView;
@property (nonatomic, assign) PIEProceedingType type;
- (void)toggleWithType:(PIEProceedingType)type;
@end
