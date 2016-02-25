//
//  PIEWithdrawMoneyView.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/16/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEWithdrawMoneyView.h"

@interface PIEWithdrawMoneyView ()

@property (weak, nonatomic) IBOutlet UIView *separatorLineView;

@end

@implementation PIEWithdrawMoneyView
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.separatorLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@0.5);
    }];
    [self.confirmWithdrawButton
     setBackgroundImage:[UIImage imageNamed:@"pie_myWallet_chargeButton"]
     forState:UIControlStateNormal];
    
    self.inputAmountTextField.keyboardType  = UIKeyboardTypePhonePad;
}

+ (PIEWithdrawMoneyView *)withdrawMoneyView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PIEWithdrawMoneyView"
                                          owner:nil options:nil] lastObject];
}

@end
