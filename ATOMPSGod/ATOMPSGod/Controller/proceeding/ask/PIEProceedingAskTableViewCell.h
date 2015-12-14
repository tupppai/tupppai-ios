//
//  PIEProceedingAskTableViewCell.h
//  TUPAI
//
//  Created by chenpeiwei on 10/12/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "iCarousel.h"
#import "SwipeView.h"
#import "PIEImageView.h"

@interface PIEProceedingAskTableViewCell : UITableViewCell<SwipeViewDelegate,SwipeViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *allWorkDescLabel;
@property (weak, nonatomic) IBOutlet SwipeView *swipeView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet PIEImageView *originView1;
@property (weak, nonatomic) IBOutlet PIEImageView *originView2;


- (void)injectSource:(NSArray*)array;
@end
