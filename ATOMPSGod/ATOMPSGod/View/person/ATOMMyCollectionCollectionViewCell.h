//
//  ATOMMyCollectionCollectionViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATOMCollectionViewModel;

@interface ATOMMyCollectionCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIImageView *collectionImageView;
@property (nonatomic, strong) ATOMCollectionViewModel *viewModel;

@end
