//
//  PIEEliteHotReplyTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/17/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteHotReplyTableViewCell.h"
#import "PIEImageEntity.h"

@implementation PIEEliteHotReplyTableViewCell
- (void)awakeFromNib {
    // Initialization code
    [self commonInit];
}

- (void)commonInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.clipsToBounds = YES;
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    _theImageView.contentMode = UIViewContentModeScaleAspectFill;
    _theImageView.clipsToBounds = YES;
    _collectView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.thumbView];
}


- (void)mansoryThumbAnimateView {
    [_thumbView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@100);
        make.trailing.equalTo(_theImageView);
        make.bottom.equalTo(_theImageView);
    }];
}

-(void)prepareForReuse {
    [super prepareForReuse];
    _followView.hidden = NO;
}

- (void)injectSauce:(DDPageVM *)viewModel {
    _ID = viewModel.ID;
    _askID = viewModel.askID;
    _followView.highlighted = viewModel.followed;
    _shareView.imageView.image = [UIImage imageNamed:@"hot_share"];
    _shareView.numberString = viewModel.shareCount;
    
    _commentView.imageView.image = [UIImage imageNamed:@"hot_comment"];
    _commentView.numberString = viewModel.commentCount;
    
    _collectView.imageView.image = [UIImage imageNamed:@"hot_star"];
    _collectView.imageView.highlightedImage = [UIImage imageNamed:@"hot_star_selected"];
    _collectView.highlighted = viewModel.collected;
    _collectView.numberString = viewModel.collectCount;
    
    _likeView.highlighted = viewModel.liked;
    _likeView.numberString = viewModel.likeCount;
    _contentLabel.text = viewModel.content;
    
    [_avatarView setImageWithURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    _nameLabel.text = viewModel.username;
    _timeLabel.text = viewModel.publishTime;
    [_theImageView setImageWithURL:[NSURL URLWithString:viewModel.imageURL] placeholderImage:[UIImage imageNamed:@"cellBG"]];
    CGFloat imageViewHeight = viewModel.imageHeight <= SCREEN_HEIGHT/2 ? viewModel.imageHeight : SCREEN_HEIGHT/2;
    [_theImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(imageViewHeight)).with.priorityHigh();
    }];
    
    //作品 type = 2 ,求p type = 1不显示ThumbAnimateView。
    if (viewModel.type == 2) {
        _thumbView.hidden = NO;
        [self mansoryThumbAnimateView];
        [_thumbView setSubviewCounts:viewModel.askImageModelArray.count];
        if (viewModel.askImageModelArray.count > 0) {
            PIEImageEntity* entity = [viewModel.askImageModelArray objectAtIndex:0];
            [_thumbView.rightView setImageWithURL:[NSURL URLWithString:entity.url] placeholderImage:[UIImage imageNamed:@"cellBG"]];
            if (viewModel.askImageModelArray.count == 2) {
                entity = viewModel.askImageModelArray[1];
                [_thumbView.leftView setImageWithURL:[NSURL URLWithString:entity.url] placeholderImage:[UIImage imageNamed:@"cellBG"]];
            }
        }
    }
    else {
        _thumbView.hidden = YES;
    }
    if (viewModel.userID == [DDUserManager currentUser].uid) {
        _followView.hidden = YES;
    }
}
-(PIEThumbAnimateView *)thumbView {
    if (!_thumbView) {
        _thumbView = [PIEThumbAnimateView new];
    }
    return _thumbView;
}


- (void)animateToggleExpanded {
    [self layoutIfNeeded];
    if (_thumbView.toExpand) {
        [_thumbView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_theImageView).with.offset(0);
            make.leading.equalTo(_theImageView).with.offset(-1);
            make.trailing.equalTo(_theImageView).with.offset(0);
            make.bottom.equalTo(_theImageView).with.offset(0);
        }];
    } else {
        [_thumbView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@100);
            make.height.equalTo(@100);
            make.trailing.equalTo(_theImageView);
            make.bottom.equalTo(_theImageView);
        }];
    }
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.7
                        options:0
                     animations:^{
                         [self.contentView layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         _thumbView.toExpand = !_thumbView.toExpand;
                     }
     ];
}

- (void)animateThumbScale:(PIEAnimateViewType)type {
    [self layoutIfNeeded];
    if (_thumbView.toExpand) {
        [_thumbView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_theImageView).with.offset(0);
            make.leading.equalTo(_theImageView).with.offset(-1);
            make.trailing.equalTo(_theImageView).with.offset(0);
            make.bottom.equalTo(_theImageView).with.offset(0);
        }];
        
        if (_thumbView.subviewCounts == 2) {
            if (type == PIEAnimateViewTypeLeft) {
                [_thumbView.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_thumbView);
                    make.trailing.equalTo(_thumbView);
                    make.bottom.equalTo(_thumbView);
                    make.width.equalTo(_thumbView).with.multipliedBy(0);
                }];
            } else {
                [_thumbView.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_thumbView);
                    make.trailing.equalTo(_thumbView);
                    make.bottom.equalTo(_thumbView);
                    make.width.equalTo(_thumbView).with.multipliedBy(1);
                }];
            }
        }
    } else {
        
        [_thumbView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@100);
            make.height.equalTo(@100);
            make.trailing.equalTo(_theImageView);
            make.bottom.equalTo(_theImageView);
        }];
        if (_thumbView.subviewCounts == 2) {
            [_thumbView.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_thumbView);
                make.trailing.equalTo(_thumbView);
                make.bottom.equalTo(_thumbView);
                make.width.equalTo(_thumbView).with.multipliedBy(0.5);
            }];
        }
    }
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.7
                        options:0
                     animations:^{
                         [self.contentView layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         _thumbView.toExpand = !_thumbView.toExpand;
                     }
     ];
}

@end