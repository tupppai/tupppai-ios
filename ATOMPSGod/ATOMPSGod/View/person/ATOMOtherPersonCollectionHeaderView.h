//
//  ATOMOtherPersonCollectionHeaderView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/17.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATOMOtherPersonCollectionHeaderView : UICollectionReusableView

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

@end
