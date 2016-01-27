//
//  PIEChannelTutorialImageTableViewCell.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/25/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialImageTableViewCell.h"
#import "PIEChannelTutorialImageModel.h"
#import "PIEChannelTutorialLockedUpView.h"

@interface PIEChannelTutorialImageTableViewCell ()

@property (nonatomic, strong) PIEChannelTutorialLockedUpView *lockedUpView;


@end

@implementation PIEChannelTutorialImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)injectImageModel:(PIEChannelTutorialImageModel *)tutorialImageModel
{
    [self.tutorialImageView
     sd_setImageWithURL:[NSURL URLWithString:tutorialImageModel.imageURL]];
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    
    /* clean lockedUpView */
    [self.lockedUpView removeFromSuperview];
    self.lockedUpView = nil;
}

#pragma mark - setters
- (void)setLocked:(BOOL)locked
{
    _locked = locked;
    
    if (locked) {
        [self addSubview:self.lockedUpView];
        
        [self.lockedUpView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self setNeedsLayout];
    }
    
}

#pragma mark - lazy loadings
- (PIEChannelTutorialLockedUpView *)lockedUpView
{
    if (_lockedUpView == nil) {
        _lockedUpView =  [PIEChannelTutorialLockedUpView lockedUpView];
    }
    
    return _lockedUpView;
}
@end
