//
//  PIEEliteReplyTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/16/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteFollowReplyTableViewCell.h"
#import "PIEImageEntity.h"
@interface PIEEliteFollowReplyTableViewCell()
@property (nonatomic, strong) UIImageView* blurView;
@end

@implementation PIEEliteFollowReplyTableViewCell
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
    _theImageView.contentMode = UIViewContentModeScaleAspectFit;
    _theImageView.clipsToBounds = YES;
    _theImageView.backgroundColor = [UIColor clearColor];
    _collectView.userInteractionEnabled = YES;
    
    [_nameLabel setFont:[UIFont lightTupaiFontOfSize:13]];
    [_contentLabel setFont:[UIFont lightTupaiFontOfSize:15]];
    [_timeLabel setFont:[UIFont lightTupaiFontOfSize:10]];
    
    [_nameLabel setTextColor:[UIColor colorWithHex:0x4a4a4a andAlpha:1.0]];
    [_contentLabel setTextColor:[UIColor colorWithHex:0x000000 andAlpha:0.9]];
    [_timeLabel setTextColor:[UIColor colorWithHex:0x000000 andAlpha:0.3]];

    [self.contentView addSubview:self.thumbView];
    
    [self.contentView insertSubview:self.blurView belowSubview:_theImageView];

    [self.blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.theImageView);
        make.bottom.equalTo(self.theImageView);
        make.leading.equalTo(self.theImageView);
        make.trailing.equalTo(self.theImageView);
    }];
}


-(UIImageView *)blurView {
    if (!_blurView) {
        _blurView = [UIImageView new];
        _blurView.contentMode = UIViewContentModeScaleAspectFill;
        _blurView.clipsToBounds = YES;
    }
    return _blurView;
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

- (void)injectSauce:(PIEPageVM *)viewModel {
    WS(ws);
    _ID = viewModel.ID;
    _askID = viewModel.askID;
    
    
    {
        if (viewModel.isMyFan) {
            _followView.highlightedImage = [UIImage imageNamed:@"pie_mutualfollow"];
        } else {
            _followView.highlightedImage = [UIImage imageNamed:@"new_reply_followed"];
        }
        _followView.highlighted = viewModel.followed;
        if (viewModel.userID == [DDUserManager currentUser].uid) {
            _followView.hidden = YES;
        } else {
            _followView.hidden = NO;
        }
    }
    
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
    
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _nameLabel.text = viewModel.username;
    _timeLabel.text = viewModel.publishTime;
    
    [_theImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.imageURL]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                ws.theImageView.image = image;
                                ws.blurView.image = [image blurredImageWithRadius:30 iterations:1 tintColor:nil];
                            }];
    

        [self mansoryThumbAnimateView];
    
        [_thumbView setSubviewCounts:viewModel.thumbEntityArray.count];
    
    if (viewModel.thumbEntityArray.count > 0) {
        PIEImageEntity* entity = [viewModel.thumbEntityArray objectAtIndex:0];
        [self.thumbView.rightView sd_setImageWithURL:[NSURL URLWithString:entity.url] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
        if (viewModel.thumbEntityArray.count == 2) {
            entity = viewModel.thumbEntityArray[1];
            [_thumbView.leftView sd_setImageWithURL:[NSURL URLWithString:entity.url] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
        }
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
