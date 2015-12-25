//
//  PIEEliteHotAskTableViewCell.h
//  TUPAI
//
//  Created by chenpeiwei on 10/22/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PIEThumbAnimateView.h"
#import "PIEPageButton.h"
#import "PIEBangView.h"

@interface PIEEliteHotAskTableViewCell : UITableViewCell
@property (nonatomic,strong) PIEPageVM* vm;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *allWorkView;
@property (weak, nonatomic) IBOutlet PIEPageButton *shareView;
@property (weak, nonatomic) IBOutlet PIEPageButton *commentView;
@property (weak, nonatomic) IBOutlet PIEBangView *bangView;
@property (weak, nonatomic) IBOutlet UIView *gapView;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel1;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel2;

@property (weak, nonatomic) IBOutlet UIImageView *followView;
//@property (nonatomic, assign) NSInteger ID;
//@property (nonatomic, assign) NSInteger askID;
- (void)injectSauce:(PIEPageVM *)viewModel;
@end
