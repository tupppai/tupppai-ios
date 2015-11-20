//
//  PIEToHelpTableViewCell.h
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/18/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TTTAttributedLabel.h"
#import "PIETextView_noSelection.h"
@interface PIEProceedingToHelpTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *downloadView;
@property (weak, nonatomic) IBOutlet UIImageView *uploadView;
@property (weak, nonatomic) IBOutlet PIETextView_noSelection *contentTextView;
- (void)injectSource:(PIEPageVM*)vm;
@end
