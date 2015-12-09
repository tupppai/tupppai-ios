//
//  PIEChannelTableViewCell.h
//  TUPAI-DEMO
//
//  Created by huangwei on 15/12/4.
//  Copyright (c) 2015年 huangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"
#import "PIEChannelViewModel.h"
@interface PIEChannelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView_banner;
@property (weak, nonatomic) IBOutlet SwipeView *swipeView;
@property (nonatomic,strong)  PIEChannelViewModel *vm;
@end
