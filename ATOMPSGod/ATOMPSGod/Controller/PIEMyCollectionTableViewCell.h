//
//  PIEMyCollectionTableViewCell.h
//  TUPAI
//
//  Created by chenpeiwei on 10/12/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEPageLikeButton.h"
@interface PIEMyCollectionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pageImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *cornerLabel;
@property (weak, nonatomic) IBOutlet PIEPageLikeButton *likeButton;
- (void)injectSauce:(DDPageVM*)vm;
@end
