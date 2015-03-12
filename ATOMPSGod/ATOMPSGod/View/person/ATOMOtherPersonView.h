//
//  ATOMOtherPersonView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"

@interface ATOMOtherPersonView : ATOMBaseView

@property (nonatomic, strong) UIImageView *topBackGroundImageView;
@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UIImageView *userSexImageView;
@property (nonatomic, strong) UILabel *attentionLabel;
@property (nonatomic, strong) UILabel *fansLabel;
@property (nonatomic, strong) UILabel *praiseLabel;
@property (nonatomic, strong) UIButton *attentionButton;

@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIButton *otherPersonUploadButton;
@property (nonatomic, strong) UIButton *otherPersonWorkButton;

@property (nonatomic, strong) UIView *blueThinView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UICollectionView *otherPersonUploadCollectionView;
@property (nonatomic, strong) UICollectionView *otherPersonWorkCollectionView;


- (void)changeBottomViewToUploadView;
- (void)changeBottomViewToWorkView;

@end
