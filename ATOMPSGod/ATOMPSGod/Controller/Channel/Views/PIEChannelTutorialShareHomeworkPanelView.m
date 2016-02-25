//
//  PIEChannelTutorialShareHomeworkPanelView.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/28/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialShareHomeworkPanelView.h"
#import "PIEChannelTutorialFinishUploadingHomeworkView.h"
#import <Photos/Photos.h>
#import "DDShareManager.h"

@interface PIEChannelTutorialShareHomeworkPanelView ()

@property (nonatomic, strong) PIEChannelTutorialFinishUploadingHomeworkView *panelView;
@property (nonatomic, strong) MASConstraint *panelViewMasConstraintCenterY;
@property (nonatomic, strong) PIEPageModel *homeworkPageModel;

@end

@implementation PIEChannelTutorialShareHomeworkPanelView


- (instancetype)init{
    self = [super init];
    
    if (self) {
        [self commonInit];
        [self setupRAC];
    }
    
    return self;
}

- (void)commonInit
{
    self.frame = [AppDelegate APP].window.bounds;
    self.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapOnSelf:)];
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.panelView];
    
    [self.panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(37);
        make.right.equalTo(self).with.offset(-37);
        make.centerX.equalTo(self);
        _panelViewMasConstraintCenterY =
        make.centerY.equalTo(self).with.offset(-SCREEN_HEIGHT);
    }];
    
    
    
}

- (void)setupRAC
{
    @weakify(self);
    [[_panelView.weiboButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self);
        PIEPageVM *pageVM = [[PIEPageVM alloc] initWithPageEntity:self.homeworkPageModel];
        
        [DDShareManager
         postSocialShare3:pageVM
         withSocialShareType:ATOMShareTypeSinaWeibo
         block:^(BOOL success) {
             if (success) {
                 [self dismiss];
                 if (_delegate != nil &&
                     [_delegate respondsToSelector:@selector(shareHomeworkPanelView:didShareHomeworkWithType:)]) {
                     [_delegate shareHomeworkPanelView:self
                              didShareHomeworkWithType:ATOMShareTypeSinaWeibo];
                 }
             }
         }];
    }];
    
    [[_panelView.qqzoneButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self);
        
        PIEPageVM *pageVM = [[PIEPageVM alloc] initWithPageEntity:self.homeworkPageModel];
        [DDShareManager
         postSocialShare3:pageVM
         withSocialShareType:ATOMShareTypeQQZone
         block:^(BOOL success) {
             if (success) {
                 [self dismiss];
                 if (_delegate != nil &&
                     [_delegate respondsToSelector:@selector(shareHomeworkPanelView:didShareHomeworkWithType:)]) {
                     [_delegate shareHomeworkPanelView:self didShareHomeworkWithType:ATOMShareTypeQQZone];
                 }
             }
         }];
    }];
    
    
    [[_panelView.wechatMomentButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self);
        
        PIEPageVM *pageVM = [[PIEPageVM alloc] initWithPageEntity:self.homeworkPageModel];
        [DDShareManager
         postSocialShare3:pageVM
         withSocialShareType:ATOMShareTypeWechatMoments
         block:^(BOOL success) {
             [self dismiss];
             if (_delegate != nil &&
                 [_delegate respondsToSelector:@selector(shareHomeworkPanelView:didShareHomeworkWithType:)]) {
                 [_delegate shareHomeworkPanelView:self
                          didShareHomeworkWithType:ATOMShareTypeWechatMoments];
             }
         }];
    }];
    
    
    [[_panelView.wechatButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self);
        PIEPageVM *pageVM = [[PIEPageVM alloc] initWithPageEntity:self.homeworkPageModel];
        [DDShareManager
         postSocialShare3:pageVM
         withSocialShareType:ATOMShareTypeWechatFriends
         block:^(BOOL success) {
             if (success) {
                 [self dismiss];
                 if (_delegate != nil &&
                     [_delegate respondsToSelector:@selector(shareHomeworkPanelView:didShareHomeworkWithType:)]) {
                     [_delegate shareHomeworkPanelView:self
                              didShareHomeworkWithType:ATOMShareTypeWechatFriends];
                 }
             }
         }];
    }];
    
    
    [[_panelView.qqFriendButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         
         PIEPageVM *pageVM = [[PIEPageVM alloc] initWithPageEntity:self.homeworkPageModel];
         
         [DDShareManager
          postSocialShare3:pageVM
          withSocialShareType:ATOMShareTypeQQFriends
          block:^(BOOL success) {
              if (success) {
                  [self dismiss];
                  if (_delegate != nil &&
                      [_delegate respondsToSelector:@selector(shareHomeworkPanelView:didShareHomeworkWithType:)]) {
                      [_delegate shareHomeworkPanelView:self
                               didShareHomeworkWithType:ATOMShareTypeQQFriends];
                  }
              }
          }];
     }];
    
    [[_panelView.dismissButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self dismiss];
     }];
    
    
}


#pragma mark - target actions
- (void)tapOnSelf:(UITapGestureRecognizer *)tap
{
    if ([self hitTest:[tap locationInView:self] withEvent:nil] == self) {
        [self dismiss];
    }
}

#pragma mark - public methods

- (void)showWithAsset:(PHAsset *)asset description:(NSString *)descriptionString pageModel:(PIEPageModel *)pageModel
{
    _panelView.descLabel.text = descriptionString;
    
    _homeworkPageModel = pageModel;
    
    [self requestImageFromAsset:asset
                    resultBlock:^(UIImage *homeworkImage) {
                        _panelView.homeworkImageView.image = homeworkImage;
                    }];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [[AppDelegate APP].window addSubview:self];
        [self layoutIfNeeded];
    
        [self.panelViewMasConstraintCenterY setOffset:0];
    
        [UIView animateWithDuration:0.35
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0.7
                            options:0
                         animations:^{
                             self.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.6];
                             [self.panelView layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                             }
                         }
         ];
    
}

- (void)dismiss
{
    [self.panelViewMasConstraintCenterY setOffset:-SCREEN_HEIGHT];
    [UIView animateWithDuration:0.12
                     animations:^{
                         [self.panelView layoutIfNeeded];
                         self.backgroundColor = [UIColor clearColor];
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [self removeFromSuperview];
                         }
                     }];
}


#pragma mark - lazy loadings
- (PIEChannelTutorialFinishUploadingHomeworkView *)panelView
{
    if (_panelView == nil) {
        _panelView = [PIEChannelTutorialFinishUploadingHomeworkView finishUploadingHomeworkView];
    }
    
    return _panelView;
}

#pragma mark - private helpers
- (void)requestImageFromAsset:(PHAsset *)asset
                  resultBlock:(void(^)(UIImage *homeworkImage))retBlock{
    PHImageManager *imageManager = [[PHImageManager alloc] init];
    [imageManager
     requestImageDataForAsset:asset
     options:nil
     resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
         UIImage *homeworkImage = [UIImage imageWithData:imageData];
         if (retBlock != nil) {
             retBlock(homeworkImage);
         }
     }];
}


@end
