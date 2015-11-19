//
//  PIENewActivityTableViewCell.h
//  TUPAI
//
//  Created by chenpeiwei on 11/17/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEPageButton.h"
#import "PIEBangView.h"

@interface PIENewActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *allWorkView;
@property (weak, nonatomic) IBOutlet PIEPageButton *shareView;
@property (weak, nonatomic) IBOutlet PIEPageButton *commentView;
@property (weak, nonatomic) IBOutlet PIEBangView *bangView;

@property (weak, nonatomic) IBOutlet UIImageView *followView;
//@property (strong, nonatomic) PIEThumbAnimateView *thumbView;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger askID;
- (void)injectSauce:(PIEPageVM *)viewModel;
@end
