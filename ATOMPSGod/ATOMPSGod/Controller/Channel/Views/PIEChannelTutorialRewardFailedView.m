//
//  PIEChannelTutorialRewardFailedView.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/27/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialRewardFailedView.h"
#import "PIEChannelTutorialRewardFailureView.h"


@interface PIEChannelTutorialRewardFailedView ()

@property (nonatomic, strong) PIEChannelTutorialRewardFailureView *panelView;
@property (nonatomic, strong) MASConstraint *panelViewMasConstraintCenterY;


@end

@implementation PIEChannelTutorialRewardFailedView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    self.frame = [AppDelegate APP].window.bounds;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnSelf:)];
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.panelView];
    [self.panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 350));
        make.centerX.equalTo(self);
        _panelViewMasConstraintCenterY =
        make.centerY.equalTo(self).with.offset(-SCREEN_HEIGHT);
    }];
    
    [[_panelView.goChargeMoneyButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         if (_delegate != nil &&
             [_delegate respondsToSelector:@selector(rewardFailedViewDidTapGoChargeMoneyButton:)]) {
             [_delegate rewardFailedViewDidTapGoChargeMoneyButton:self];
         }
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
- (void)show{
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
                     }];
}

- (void)dismiss{
    [self.panelViewMasConstraintCenterY setOffset:SCREEN_HEIGHT];
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

- (PIEChannelTutorialRewardFailureView *)panelView
{
    if (_panelView == nil) {
        _panelView = [PIEChannelTutorialRewardFailureView rewardFailureView];
    }
    
    return _panelView;
}

@end
