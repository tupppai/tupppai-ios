//
//  PIEChargeMoneyPanelView.m
//  TUPAI
//
//  Created by huangwei on 16/1/22.
//  Copyright © 2016年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChargeMoneyPanelView.h"
#import "ReactiveCocoa/ReactiveCocoa.h"

@interface PIEChargeMoneyPanelView ()

@property (nonatomic, assign) CGFloat minimumTextFieldWidth;

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
    self.moneyCountTextField.placeholder = @"0.00";
    
    
    CGSize strSize = [self.moneyCountTextField.placeholder
                      boundingRectWithSize:CGSizeMake(300, 40)
                                                  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30]}
                                                  context:nil].size;
    self.minimumTextFieldWidth = strSize.width;
    
    @weakify(self);
    [[[self.moneyCountTextField rac_textSignal]
    skip:1] subscribeNext:^(NSString *inputStr) {
        @strongify(self);
        
        CGSize strSize = [inputStr boundingRectWithSize:CGSizeMake(300, 40)
                                                options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30]}
                                                context:nil].size;
        [self.moneyCountTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(fmax(strSize.width, self.minimumTextFieldWidth));
        }];
        
        [self setNeedsLayout];
    }];
    
    
}


#pragma mark - factory methods
+ (PIEChargeMoneyPanelView *)chargeMoneyPanel
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PIEChargeMoneyPanelView"
                                         owner:nil options:nil] lastObject];
}



@end
