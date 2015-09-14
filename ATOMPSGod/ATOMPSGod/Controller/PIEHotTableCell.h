//
//  PIEAskCellTableViewCell.h
//  
//
//  Created by chenpeiwei on 9/11/15.
//
//

#import <UIKit/UIKit.h>
#import "DDPageVM.h"
#import "PIEThumbAnimateView.h"
#import "PIEThumbAnimateView2.h"

@interface PIEHotTableCell : UITableViewCell
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
@property (weak, nonatomic) IBOutlet PIEThumbAnimateView *thumbAnimateView;
@property (strong, nonatomic) PIEThumbAnimateView2 *thumbView;

- (void)configCell:(DDPageVM *)viewModel row:(NSInteger)row;
- (void)toggleExpanded;
@end
