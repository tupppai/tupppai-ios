//
//  PIEAskCellTableViewCell.h
//
//
//  Created by chenpeiwei on 9/11/15.
//
//

#import <UIKit/UIKit.h>

#import "PIEThumbAnimateView.h"
#import "PIEPageButton.h"
#import "PIEPageLikeButton.h"
typedef NS_ENUM(NSInteger, PIEAnimateViewType) {
    PIEAnimateViewTypeLeft,
    PIEAnimateViewTypeRight
};

@interface PIEReplyTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *allWorkView;
@property (weak, nonatomic) IBOutlet PIEPageButton *shareView;
@property (weak, nonatomic) IBOutlet PIEPageButton *collectView;
@property (weak, nonatomic) IBOutlet PIEPageButton *commentView;
@property (weak, nonatomic) IBOutlet PIEPageLikeButton *likeView;
@property (weak, nonatomic) IBOutlet UIImageView *followView;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger askID;

@property (strong, nonatomic) PIEThumbAnimateView *thumbView;

- (void)injectSauce:(DDPageVM *)viewModel ;
- (void)animateToggleExpanded ;
- (void)animateThumbScale:(PIEAnimateViewType)type;
@end
