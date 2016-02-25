//
//  PIEProceedingAskTableViewCell_NoGap.h
//  TUPAI
//
//  Created by chenpeiwei on 11/25/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
//#import "iCarousel.h"
#import "SwipeView.h"
#import "PIEImageView.h"

@interface PIEProceedingAskTableViewCell_NoGap : UITableViewCell<SwipeViewDelegate,SwipeViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *separator;

@property (weak, nonatomic) IBOutlet SwipeView *swipeView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet PIEImageView *originView1;
@property (weak, nonatomic) IBOutlet PIEImageView *originView2;


// (新需求)：“进行中”的cell添加频道信息
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadTimeLabel;



- (void)injectSource:(NSArray*)array;
@end
