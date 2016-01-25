//
//  PIEChargeMoneyPanelView.h
//  TUPAI
//
//  Created by huangwei on 16/1/22.
//  Copyright © 2016年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIEChargeMoneyPanelView : UIView

+ (PIEChargeMoneyPanelView *)chargeMoneyPanel;
@property (weak, nonatomic) IBOutlet UITextField *moneyCountTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end
