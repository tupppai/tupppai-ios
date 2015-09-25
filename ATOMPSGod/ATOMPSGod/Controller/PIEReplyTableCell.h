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
#import "PIEHighlightableLabel.h"
#import "PIECountLabel.h"
#import "PIEButton.h"
//home reply
@interface PIEReplyTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *allWorkView;
@property (weak, nonatomic) IBOutlet PIEButton *shareView;
@property (weak, nonatomic) IBOutlet PIEButton *collectView;
@property (weak, nonatomic) IBOutlet PIEButton *commentView;
@property (weak, nonatomic) IBOutlet UIImageView *likeView;

//@property (weak, nonatomic) IBOutlet PIECountLabel *shareCountLabel;
//@property (weak, nonatomic) IBOutlet PIECountLabel *collectCountLabel;
//@property (weak, nonatomic) IBOutlet PIECountLabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet PIEHighlightableLabel *likeCountLabel;



@property (strong, nonatomic) PIEThumbAnimateView *thumbView;

- (void)configCell:(DDPageVM *)viewModel row:(NSInteger)row;
- (void)animateToggleExpanded ;
@end
