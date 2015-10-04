//
//  PIEFriendAskTableViewCell.h
//  TUPAI
//
//  Created by chenpeiwei on 10/4/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DDPageVM.h"
@interface PIEFriendAskTableViewCell : UITableViewCell<iCarouselDataSource,iCarouselDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *allWorkDescLabel;
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
- (void)injectSource:(DDPageVM*)vm;
@end
