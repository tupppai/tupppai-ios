//
//  PIEChannelTutorialRewardFailedView.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/27/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PIEChannelTutorialRewardFailedView;


@protocol PIEChannelTutorialRewardFailedViewDelegate <NSObject>

@optional

- (void)rewardFailedViewDidTapGoChargeMoneyButton:
(nonnull PIEChannelTutorialRewardFailedView *)rewardFailedView ;

@end

@interface PIEChannelTutorialRewardFailedView : UIView

@property (nonatomic, weak) id<PIEChannelTutorialRewardFailedViewDelegate> delegate;

- (void)show;
- (void)dismiss;

@end
