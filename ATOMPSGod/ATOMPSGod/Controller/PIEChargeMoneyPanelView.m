//
//  PIEChargeMoneyPanelView.m
//  TUPAI
//
//  Created by huangwei on 16/1/22.
//  Copyright © 2016年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChargeMoneyPanelView.h"

@interface PIEChargeMoneyPanelView ()

@property (nonatomic, assign) CGFloat minimumTextFieldWidth;
@property (nonatomic, assign) MASConstraint *textFieldMASWidth;

@end

@implementation PIEChargeMoneyPanelView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self commonInit];
}


#pragma mark - UI components setup

- (void)commonInit
{
    
    self.minimumTextFieldWidth = 40;
    
    self.moneyCountTextField.placeholder = @"0";
    self.moneyCountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.moneyCountTextField.textAlignment = NSTextAlignmentCenter;
    [self.moneyCountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
       self.textFieldMASWidth = make.width.mas_equalTo(@(self.minimumTextFieldWidth));
    }];
    @weakify(self);
    [[[self.moneyCountTextField rac_textSignal]
    skip:1] subscribeNext:^(NSString *inputStr) {
        @strongify(self);
        
        CGSize strSize = [inputStr boundingRectWithSize:CGSizeMake(300, 40)
                                                options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30]}
                                                context:nil].size;
        [self.textFieldMASWidth setOffset:(fmax(strSize.width, self.minimumTextFieldWidth))];
        
        [self setNeedsLayout];
    }];
  
    
    [[self.moneyCountTextField rac_textSignal]subscribeNext:^(NSString* x) {
        self.confirmButton.enabled = [x floatValue] > 0.0;
    }];
}


#pragma mark - factory methods
+ (PIEChargeMoneyPanelView *)chargeMoneyPanel
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PIEChargeMoneyPanelView"
                                         owner:nil options:nil] lastObject];
}



@end
