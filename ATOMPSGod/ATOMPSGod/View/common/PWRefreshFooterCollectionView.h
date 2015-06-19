//
//  PWRefreshFooterCollectionView.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/19/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATOMNoDataView.h"
@interface PWRefreshFooterCollectionView : UICollectionView
@property (nonatomic, strong) ATOMNoDataView *noDataView;
@property (nonatomic, weak) id<PWRefreshBaseCollectionViewDelegate> psDelegate;
-(void)reloadDataCustom;

@end
