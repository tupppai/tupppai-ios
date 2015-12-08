//
//  PIENotificationFollowTableViewCell.h
//  TUPAI
//
//  Created by chenpeiwei on 10/14/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIENotificationVM.h"
@interface PIENotificationFollowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
- (void)injectSauce:(PIENotificationVM*)vm;
@end
