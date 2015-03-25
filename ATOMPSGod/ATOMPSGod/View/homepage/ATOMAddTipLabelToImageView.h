//
//  ATOMAddTipLabelToImageView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/6.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"

@interface ATOMAddTipLabelToImageView : ATOMBaseView

@property (nonatomic, strong) UIImageView *workImageView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImage *workImage;
@property (nonatomic, strong) UIButton *changeTipLabelDirectionButton;
@property (nonatomic, strong) UIButton *deleteTipLabelButton;
@property (nonatomic, strong) UIButton *xlButton;
@property (nonatomic, strong) UIButton *wxButton;
@property (nonatomic, strong) UIButton *qqButton;
@property (nonatomic, strong) UIButton *qqzoneButton;

- (void)showOperationButton;
- (void)hideOperationButton;
- (BOOL)isOperationButtonShow;
- (void)addTemporaryPointAt:(CGPoint)point;
- (void)removeTemporaryPoint;
- (void)changeStatusOfShareButton:(UIButton *)button;

@end
