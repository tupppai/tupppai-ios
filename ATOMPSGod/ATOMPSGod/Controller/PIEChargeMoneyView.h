//
//  PIEChargeMoneyView.h
//  TUPAI
//
//  Created by chenpeiwei on 1/26/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEChargeMoneyPanelView.h"

@class PIEChargeMoneyView;

@protocol PIEChargeMoneyViewDelegate <NSObject>

@optional

- (void)chargeMoneyView:(nonnull PIEChargeMoneyView *)chargeMoneyView tapConfirmButtonWithAmount:(double)amount;
- (void)chargeMoneyViewDidDismiss:(nonnull PIEChargeMoneyView *)chargeMoneyView ;

@end

@interface PIEChargeMoneyView : UIView
@property (nonatomic, weak) id<PIEChargeMoneyViewDelegate> delegate;
- (void)showWithAmoutToBeCharge:(double)amount;
- (void)dismiss;
@end
