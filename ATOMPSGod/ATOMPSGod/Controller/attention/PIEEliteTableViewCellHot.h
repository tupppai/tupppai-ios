//
//  PIEFollowHotTableViewCell.h
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/20/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPageVM.h"
#import "PIEThumbAnimateView.h"

@interface PIEEliteTableViewCellHot : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *allWorkView;
@property (weak, nonatomic) IBOutlet UIImageView *shareView;
@property (weak, nonatomic) IBOutlet UIImageView *collectView;
@property (weak, nonatomic) IBOutlet UIImageView *commentView;
@property (weak, nonatomic) IBOutlet UIImageView *likeView;

@property (weak, nonatomic) IBOutlet UILabel *shareCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (strong, nonatomic) PIEThumbAnimateView *thumbView;

- (void)injectSauce:(DDPageVM *)viewModel ;
- (void)animateToggleExpanded ;

@end
