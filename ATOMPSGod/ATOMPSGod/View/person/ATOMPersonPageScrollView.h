//
//  ATOMPersonPageScrollView.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/8/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ATOMOtherPersonCollectionViewTypeAsk = 0,
    ATOMOtherPersonCollectionViewTypeReply
}ATOMOtherPersonCollectionViewType;

@interface ATOMPersonPageScrollView : UIScrollView
@property (nonatomic, assign) ATOMOtherPersonCollectionViewType currentType;
@property (nonatomic, strong) UICollectionView *otherPersonUploadCollectionView;
@property (nonatomic, strong) UICollectionView *otherPersonWorkCollectionView;

- (void)toggleCollectionView:(ATOMOtherPersonCollectionViewType)type;
@end
