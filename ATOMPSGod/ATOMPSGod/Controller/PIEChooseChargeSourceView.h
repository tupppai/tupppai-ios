//
//  PIEChooseChargeSourceView.h
//  TUPAI
//
//  Created by chenpeiwei on 1/26/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PIEWalletChargeSourceType) {
    PIEWalletChargeSourceTypeAlipay,
    PIEWalletChargeSourceTypeWechat,
};

@class PIEChooseChargeSourceView;

@protocol PIEChooseChargeSourceViewDelegate <NSObject>
@optional
- (void)chooseChargeSourceView:(nonnull PIEChooseChargeSourceView *)chooseChargeSourceView tapButtonOfIndex:(NSInteger)index;
@end

@interface PIEChooseChargeSourceView : UIView
@property (nonatomic, weak) id<PIEChooseChargeSourceViewDelegate> delegate;
@property (nonatomic, assign) PIEWalletChargeSourceType chargeType;

- (void)show;
-(void)dismiss;
@end
