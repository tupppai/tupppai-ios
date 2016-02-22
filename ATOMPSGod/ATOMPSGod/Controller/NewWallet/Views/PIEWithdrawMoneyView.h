//
//  PIEWithdrawMoneyView.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/16/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIEWithdrawMoneyView : UIView
@property (weak, nonatomic) IBOutlet UITextField *inputAmountTextField;
@property (weak, nonatomic) IBOutlet UILabel     *remainingBalanceLabel;
@property (weak, nonatomic) IBOutlet UIButton    *confirmWithdrawButton;


+ (PIEWithdrawMoneyView *)withdrawMoneyView;

@end
