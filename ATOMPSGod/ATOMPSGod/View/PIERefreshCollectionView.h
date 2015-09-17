//
//  PIERefreshCollectionView.h
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/17/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIERefreshCollectionView : UICollectionView
@property (nonatomic, weak) id<PWRefreshBaseCollectionViewDelegate> psDelegate;
@property (nonatomic, assign) BOOL toRefreshTop;
@property (nonatomic, assign) BOOL toRefreshBottom;

@end
