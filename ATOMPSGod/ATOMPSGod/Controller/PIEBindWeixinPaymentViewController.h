//
//  PIEBindWeixinPaymentViewController.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/21/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "DDBaseVC.h"
@class PIEBindWeixinPaymentViewController;

@protocol PIEBindWeixinPaymentViewControllerDelegate <NSObject>
@optional
- (void)bindWechatViewController:(PIEBindWeixinPaymentViewController *)bindWechatViewController success:(BOOL)success;
@end

@interface PIEBindWeixinPaymentViewController : DDBaseVC
@property (nonatomic,weak)id <PIEBindWeixinPaymentViewControllerDelegate> delegate;
@end
