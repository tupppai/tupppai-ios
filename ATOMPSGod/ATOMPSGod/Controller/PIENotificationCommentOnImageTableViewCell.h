//
//  PIENotificationCommentTableViewCell2.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/14/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PIENotificationVM;

@interface PIENotificationCommentOnImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel     *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel     *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel     *replyLabel;
@property (weak, nonatomic) IBOutlet UILabel     *originalCommentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pageImageView;


- (void)injectSauce:(PIENotificationVM*)vm;

@end
