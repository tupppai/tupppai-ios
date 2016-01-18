//
//  PIEAskCellTableViewCell.m
//
//
//  Created by chenpeiwei on 9/11/15.
//
//

#import "PIENewReplyTableCell.h"
#import "PIEModelImage.h"
#import "POP.h"
//#import "MMPlaceHolder.h"
@interface PIENewReplyTableCell()
@property (nonatomic, strong) UIImageView* blurView;
@end

@implementation PIENewReplyTableCell

- (void)awakeFromNib {
    // Initialization code
    [self commonInit];
//    [self showPlaceHolder];
}

- (void)commonInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.clipsToBounds = YES;
//    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
//    _avatarView.clipsToBounds = YES;
    _theImageView.contentMode = UIViewContentModeScaleAspectFit;
    _theImageView.backgroundColor = [UIColor clearColor];
    _theImageView.clipsToBounds = YES;
    [_nameLabel setFont:[UIFont lightTupaiFontOfSize:13]];
    [_contentLabel setFont:[UIFont lightTupaiFontOfSize:15]];
    [_timeLabel setFont:[UIFont lightTupaiFontOfSize:10]];
    
    [_nameLabel setTextColor:[UIColor colorWithHex:0x4a4a4a andAlpha:1.0]];
    [_timeLabel setTextColor:[UIColor colorWithHex:0x4a4a4a andAlpha:0.3]];
    [_contentLabel setTextColor:[UIColor colorWithHex:0x000000 andAlpha:0.9]];
    
    _followView.contentMode = UIViewContentModeCenter;

    [self configThumbAnimateView];
    
    [self.contentView insertSubview:self.blurView belowSubview:_theImageView];
    [self.blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.theImageView);
        make.bottom.equalTo(self.theImageView);
        make.leading.equalTo(self.theImageView);
        make.trailing.equalTo(self.theImageView);
    }];
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
    [self removeKVO];
}

-(void)dealloc {
    [self removeKVO];
}


#pragma mark - public methods
- (void)hideThumbnailImage
{
    // 隐藏右下角的小图
    self.thumbView.hidden = YES;
}

- (void)injectSauce:(PIEPageVM *)viewModel {
    WS(ws);
    _vm = viewModel;
    [self addKVO];
    NSString *urlString_avatar = [viewModel.avatarURL trimToImageWidth:_avatarView.frame.size.width*SCREEN_SCALE];
    NSString *urlString_imageView = [viewModel.imageURL trimToImageWidth:SCREEN_WIDTH_RESOLUTION];
    
    [_theImageView sd_setImageWithURL:[NSURL URLWithString:urlString_imageView]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                ws.theImageView.image = image;
                                ws.blurView.image = [image blurredImageWithRadius:30 iterations:1 tintColor:nil];
                            }];
    [_avatarView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:urlString_avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _avatarView.isV = viewModel.isV;

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

    
//    _likeView.highlighted = viewModel.liked;
//    _likeView.numberString = viewModel.likeCount;
    [_likeView initStatus:viewModel.loveStatus numberString:viewModel.likeCount];
    _contentLabel.text = viewModel.content;
    
    
    _nameLabel.text = viewModel.username;
    _timeLabel.text = viewModel.publishTime;
    

    _thumbView.subviewCounts = viewModel.models_image.count;
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

- (void)animateToggleExpanded {
    [self layoutIfNeeded];
    if (!_thumbView.enlarged) {
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
                         _thumbView.enlarged = !_thumbView.enlarged;
                     }
     ];
}

- (void)animateThumbScale:(PIEThumbAnimateViewType)type {
    [self layoutIfNeeded];
    if (!_thumbView.enlarged) {
        [_thumbView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_theImageView).with.offset(0);
            make.leading.equalTo(_theImageView).with.offset(-1);
            make.trailing.equalTo(_theImageView).with.offset(0);
            make.bottom.equalTo(_theImageView).with.offset(0);
        }];
        
        if (_thumbView.subviewCounts == 2) {
            if (type == PIEThumbAnimateViewTypeLeft) {
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
                         _thumbView.enlarged = !_thumbView.enlarged;
                     }
     ];
}


#pragma mark - lazy loadings
-(UIImageView *)blurView {
    if (!_blurView) {
        _blurView = [UIImageView new];
        _blurView.contentMode = UIViewContentModeScaleAspectFill;
        _blurView.clipsToBounds = YES;
    }
    return _blurView;
}


- (void)addKVO {
    [_vm addObserver:self forKeyPath:@"loveStatus" options:NSKeyValueObservingOptionNew context:NULL];
    [_vm addObserver:self forKeyPath:@"likeCount" options:NSKeyValueObservingOptionNew context:NULL];
    [_vm addObserver:self forKeyPath:@"followed" options:NSKeyValueObservingOptionNew context:NULL];
}
- (void)removeKVO {
    @try{
        [_vm removeObserver:self forKeyPath:@"loveStatus"];
        [_vm removeObserver:self forKeyPath:@"likeCount"];
        [_vm removeObserver:self forKeyPath:@"followed"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loveStatus"]) {
        NSInteger newLovedCount = [[change objectForKey:@"new"]integerValue];
        self.likeView.status = newLovedCount;
    } else     if ([keyPath isEqualToString:@"likeCount"]) {
        NSInteger newLikeCount = [[change objectForKey:@"new"]integerValue];
        self.likeView.number = newLikeCount;
    } else     if ([keyPath isEqualToString:@"followed"]) {
        BOOL newFollowed = [[change objectForKey:@"new"]boolValue];
        self.followView.highlighted = newFollowed;
    }
}

@end
