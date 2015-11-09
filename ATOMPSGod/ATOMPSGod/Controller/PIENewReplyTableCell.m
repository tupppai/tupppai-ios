//
//  PIEAskCellTableViewCell.m
//
//
//  Created by chenpeiwei on 9/11/15.
//
//

#import "PIENewReplyTableCell.h"
#import "PIEImageEntity.h"
#import "POP.h"
@interface PIENewReplyTableCell()
@property (nonatomic, strong) UIImageView* blurView;
@end

@implementation PIENewReplyTableCell

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
    _theImageView.backgroundColor = [UIColor clearColor];
    _theImageView.clipsToBounds = YES;
    _collectView.userInteractionEnabled = YES;
    [self configThumbAnimateView];
    
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

- (void)configThumbAnimateView {
    _thumbView = [PIEThumbAnimateView new];
    [self.contentView addSubview:_thumbView];
    [self mansoryInitThumbAnimateView];
}
- (void)mansoryInitThumbAnimateView {
    [_thumbView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@100);
        make.trailing.equalTo(_theImageView);
        make.bottom.equalTo(_theImageView);
    }];
}
-(void)prepareForReuse {
    [super prepareForReuse];
    [self mansoryInitThumbAnimateView];
}
- (void)injectSauce:(DDPageVM *)viewModel {
    WS(ws);

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
    
    [_avatarView setImageWithURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"cellBG"]];
    
    _nameLabel.text = viewModel.username;
    _timeLabel.text = viewModel.publishTime;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:viewModel.imageURL]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [_theImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"cellBG"] success:^(NSURLRequest *  request, NSHTTPURLResponse *  response, UIImage *  image) {
        ws.theImageView.image = image;
        ws.blurView.image = [image blurredImageWithRadius:30 iterations:1 tintColor:nil];
    } failure:nil];
    
    //    CGFloat imageViewHeight = MIN(viewModel.imageHeight, SCREEN_HEIGHT/2) ;
//    imageViewHeight = MAX(100,imageViewHeight);
//    imageViewHeight = MIN(SCREEN_WIDTH, imageViewHeight);

//    [_theImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@(SCREEN_WIDTH)).with.priorityHigh();
//    }];
    _thumbView.subviewCounts = viewModel.thumbEntityArray.count;
    if (viewModel.thumbEntityArray.count > 0) {
        PIEImageEntity* entity = [viewModel.thumbEntityArray objectAtIndex:0];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:entity.url]];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        [self.thumbView.rightView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"cellBG"] success:^(NSURLRequest *  request, NSHTTPURLResponse *  response, UIImage *  image) {
            ws.thumbView.rightView.image = image;
            ws.thumbView.blurView.image = [image blurredImageWithRadius:30 iterations:1 tintColor:nil];
        } failure:nil];
        if (viewModel.thumbEntityArray.count == 2) {
            entity = viewModel.thumbEntityArray[1];
            [_thumbView.leftView setImageWithURL:[NSURL URLWithString:entity.url] placeholderImage:[UIImage imageNamed:@"cellBG"]];
        }
    }
    else {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:viewModel.imageURL]];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        [self.thumbView.rightView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"cellBG"] success:^(NSURLRequest *  request, NSHTTPURLResponse *  response, UIImage *  image) {
            ws.thumbView.rightView.image = image;
            ws.thumbView.blurView.image = [image blurredImageWithRadius:30 iterations:1 tintColor:nil];
        } failure:nil];
    }
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
