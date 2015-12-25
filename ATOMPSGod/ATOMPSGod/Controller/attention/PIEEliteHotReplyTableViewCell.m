//
//  PIEEliteHotReplyTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/17/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteHotReplyTableViewCell.h"
#import "PIEModelImage.h"
#import "PIECommentEntity.h"
#import "FXBlurView.h"
@interface PIEEliteHotReplyTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *gapView;
@property (nonatomic, strong) UIImageView* blurView;
@end
@implementation PIEEliteHotReplyTableViewCell
- (void)awakeFromNib {
    [self commonInit];
}
- (void)commonInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    _theImageView.contentMode = UIViewContentModeScaleAspectFit;
    _theImageView.clipsToBounds = YES;
    _theImageView.backgroundColor = [UIColor clearColor];
//    _collectView.userInteractionEnabled = YES;

    [_nameLabel setFont:[UIFont lightTupaiFontOfSize:13]];
    [_contentLabel setFont:[UIFont lightTupaiFontOfSize:15]];
    [_commentLabel1 setFont:[UIFont lightTupaiFontOfSize:13]];
    [_commentLabel2 setFont:[UIFont lightTupaiFontOfSize:13]];
    
    [_nameLabel setTextColor:[UIColor colorWithHex:0x4a4a4a andAlpha:1.0]];
    [_contentLabel setTextColor:[UIColor colorWithHex:0x000000 andAlpha:0.9]];
    [_commentLabel1 setTextColor:[UIColor colorWithHex:0x000000 andAlpha:0.8]];
    [_commentLabel2 setTextColor:[UIColor colorWithHex:0x000000 andAlpha:0.8]];
    
    [_followView setContentMode:UIViewContentModeCenter];
    
    [self.contentView addSubview:self.thumbView];
    [self.contentView insertSubview:self.blurView belowSubview:_theImageView];

    [self.blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.theImageView);
        make.bottom.equalTo(self.theImageView);
        make.leading.equalTo(self.theImageView);
        make.trailing.equalTo(self.theImageView);
    }];
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
    _commentLabel2.text = @"";
    _commentLabel1.text = @"";
    
    [_commentLabel1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_commentLabel2.mas_top).with.offset(0).priorityHigh();
    }];
    [_commentLabel2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_gapView.mas_top).with.offset(0).priorityHigh();
    }];

}

- (void)injectSauce:(PIEPageVM *)viewModel {
    WS(ws);
    _vm = viewModel;
    NSString *urlString_avatar = [viewModel.avatarURL trimToImageWidth:_avatarView.frame.size.width*SCREEN_SCALE];
    NSString *urlString_imageView = [viewModel.imageURL trimToImageWidth:SCREEN_WIDTH_RESOLUTION];
//    _ID = viewModel.ID;
//    _askID = viewModel.askID;
    
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
    
//    _collectView.imageView.image = [UIImage imageNamed:@"hot_star"];
//    _collectView.imageView.highlightedImage = [UIImage imageNamed:@"hot_star_selected"];
//    _collectView.highlighted = viewModel.collected;
//    _collectView.numberString = viewModel.collectCount;
    
    [_likeView initStatus:viewModel.lovedCount numberString:viewModel.likeCount];
    _contentLabel.text = viewModel.content;
    
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:urlString_avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _nameLabel.text = viewModel.username;
    
    [_theImageView sd_setImageWithURL:[NSURL URLWithString:urlString_imageView]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                ws.theImageView.image = image;
                                ws.blurView.image = [image blurredImageWithRadius:30 iterations:1 tintColor:nil];
                            }];
    
    if (viewModel.models_comment.count > 0) {
        PIECommentEntity* commentEntity1  = viewModel.models_comment[0];
        _commentLabel1.text = [NSString stringWithFormat:@"%@: %@",commentEntity1.nickname,commentEntity1.content];
       
        [_commentLabel2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_gapView.mas_top).with.offset(-25).with.priorityHigh();
        }];
        
        if (viewModel.models_comment.count > 1) {
            
            [_commentLabel1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_commentLabel2.mas_top).with.offset(-10).with.priorityHigh();
            }];
            
            PIECommentEntity* commentEntity2  = viewModel.models_comment[1];
            _commentLabel2.text = [NSString stringWithFormat:@"%@: %@",commentEntity2.nickname,commentEntity2.content];
        }
    }
    
        [self mansoryThumbAnimateView];
        [_thumbView setSubviewCounts:viewModel.models_image.count];
    
    if (viewModel.models_image.count > 0) {
        PIEModelImage* entity = [viewModel.models_image objectAtIndex:0];

        NSString *urlString_imageView1 = [entity.url trimToImageWidth:SCREEN_WIDTH_RESOLUTION];
        [self.thumbView.rightView sd_setImageWithURL:[NSURL URLWithString:urlString_imageView1] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
        
        if (viewModel.models_image.count == 2) {
            entity = viewModel.models_image[1];
            NSString *urlString_imageView2 = [entity.url trimToImageWidth:SCREEN_WIDTH_RESOLUTION];

            [_thumbView.leftView sd_setImageWithURL:[NSURL URLWithString:urlString_imageView2] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
        }
    }
}
-(PIEThumbAnimateView *)thumbView {
    if (!_thumbView) {
        _thumbView = [PIEThumbAnimateView new];
    }
    return _thumbView;
}
-(UIImageView *)blurView {
    if (!_blurView) {
        _blurView = [UIImageView new];
        _blurView.contentMode = UIViewContentModeScaleAspectFill;
        _blurView.clipsToBounds = YES;
    }
    return _blurView;
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