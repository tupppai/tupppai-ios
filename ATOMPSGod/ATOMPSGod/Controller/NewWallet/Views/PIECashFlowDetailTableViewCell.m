//
//  PIECashFlowDetailTableViewCell.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/16/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIECashFlowDetailTableViewCell.h"
#import "PIEAvatarView.h"
#import "PIECashFlowModel.h"

#define kPIECashFlowIncomeColor  0xF5A623
#define kPIECashFlowOutcomeColor 0x8DC81B

@interface PIECashFlowDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet PIEAvatarView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentCreatedTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cashFlowTypeImageView;

@end

@implementation PIECashFlowDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)injectModel:(PIECashFlowModel *)model
{
    [self.avatarView.avatarImageView
     sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl]];
    
    if (model.avatarUrl == nil) {
        self.avatarView.hidden = YES;
        self.cashFlowTypeImageView.hidden = NO;
        if (model.cashFlowModelType == PIECashFlowModelTypeIncome) {
            self.cashFlowTypeImageView.image = [UIImage imageNamed:@"pie_myWallet_deposit_icon"];
        }else if (model.cashFlowModelType == PIECashFlowModelTypeOutcome){
            self.cashFlowTypeImageView.image = [UIImage imageNamed:@"pie_myWallet_withdraw_icon"];
        }
    }else{
        self.avatarView.hidden = NO;
        self.cashFlowTypeImageView.hidden = YES;
        
        if (model.cashFlowModelType == PIECashFlowModelTypeIncome) {
            self.amountLabel.text =
            [NSString stringWithFormat:@"+ %@", [@(model.amount) stringValue]];
            self.amountLabel.textColor = [UIColor colorWithHex:kPIECashFlowIncomeColor];
            
        }else if (model.cashFlowModelType == PIECashFlowModelTypeOutcome){
            self.amountLabel.text =
            [NSString stringWithFormat:@"- %@", [@(model.amount) stringValue]];
            self.amountLabel.textColor = [UIColor colorWithHex:kPIECashFlowOutcomeColor];
        }
    }
    self.paymentDescLabel.text        = model.paymentDesc;
    self.paymentCreatedTimeLabel.text = model.paymentCreatedTime;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    
    // set avatarView & cashFlowIconView hidden
    self.avatarView.hidden = YES;
    self.cashFlowTypeImageView.hidden = YES;
    
}

@end
