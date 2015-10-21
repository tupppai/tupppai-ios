//
//  PIEToHelpTableViewCell2.h
//  TUPAI
//
//  Created by chenpeiwei on 10/9/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIEToHelpTableViewCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *paticipantLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *deleteView;
- (void)injectSource:(DDPageVM*)vm;
@end
