//
//  PIEToHelpTableViewCell.h
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/18/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TTTAttributedLabel.h"
#import "PIETextView_linkDetection.h"
#import "PIEAvatarImageView.h"
@interface PIEProceedingToHelpTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PIEAvatarImageView *avatarView;

@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *downloadView;
@property (weak, nonatomic) IBOutlet UIImageView *uploadView;
@property (weak, nonatomic) IBOutlet PIETextView_linkDetection *contentTextView;
@property (weak, nonatomic) IBOutlet UIView *separator;


// (新需求）：“进行中”添加频道信息
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;



- (void)injectSource:(PIEPageVM*)vm;
@end
