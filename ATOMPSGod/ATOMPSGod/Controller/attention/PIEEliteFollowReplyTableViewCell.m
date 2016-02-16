//
//  PIEEliteReplyTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/16/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteFollowReplyTableViewCell.h"
#import "PIEModelImage.h"
@interface PIEEliteFollowReplyTableViewCell()
@property (nonatomic, strong) UIImageView* blurView;
@end

@implementation PIEEliteFollowReplyTableViewCell
- (void)awakeFromNib {
    // Initialization code
    [self commonInit];
}
-(void)dealloc {
    [self removeKVO];
}
- (void)commonInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.clipsToBounds = YES;

    _theImageView.contentMode = UIViewContentModeScaleAspectFit;
    _theImageView.clipsToBounds = YES;
    _theImageView.backgroundColor = [UIColor clearColor];
        
    [_nameLabel setFont:[UIFont lightTupaiFontOfSize:13]];
    [_contentLabel setFont:[UIFont lightTupaiFontOfSize:15]];
    [_timeLabel setFont:[UIFont lightTupaiFontOfSize:10]];
    
//    [_nameLabel setTextColor:[UIColor colorWithHex:0x4a4a4a andAlpha:1.0]];
//    [_contentLabel setTextColor:[UIColor colorWithHex:0x000000 andAlpha:0.9]];
//    [_timeLabel setTextColor:[UIColor colorWithHex:0x000000 andAlpha:0.3]];
    
    [_nameLabel setTextColor:[UIColor colorWithHex:0x4a4a4a]];
    [_contentLabel setTextColor:[UIColor colorWithHex:0x000000]];
    [_timeLabel setTextColor:[UIColor colorWithHex:0xB2B2B2]];
    
    _nameLabel.opaque    = YES;
    _contentLabel.opaque = YES;
    _timeLabel.opaque    = YES;
    _nameLabel.backgroundColor    = [UIColor whiteColor];
    _contentLabel.backgroundColor = [UIColor whiteColor];
    _timeLabel.backgroundColor    = [UIColor whiteColor];

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
    [self removeKVO];
}

- (void)injectSauce:(PIEPageVM *)viewModel {
    WS(ws);
    {
        _vm = viewModel;
        [self addKVO];
    }
    NSString *urlString_avatar = [viewModel.avatarURL trimToImageWidth:_avatarView.frame.size.width*SCREEN_SCALE];
    NSString *urlString_imageView = [viewModel.imageURL trimToImageWidth:SCREEN_WIDTH_RESOLUTION];

    [_theImageView sd_setImageWithURL:[NSURL URLWithString:urlString_imageView]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                ws.theImageView.image = image;
//                                ws.blurView.image = [image blurredImageWithRadius:30 iterations:1 tintColor:nil];
                                [image backgroundBlurredImageView:ws.blurView
                                                       WithRadius:30
                                                       iterations:1
                                                        tintColor:nil];
                            }];
//    [_avatarView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:urlString_avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];

    _avatarView.url = urlString_avatar;
    _avatarView.isV = viewModel.isV;
    

    _shareView.imageView.image = [UIImage imageNamed:@"hot_share"];
    _shareView.numberString = viewModel.shareCount;
    
    _commentView.imageView.image = [UIImage imageNamed:@"hot_comment"];
    _commentView.numberString = viewModel.commentCount;

    [_likeView initStatus:viewModel.loveStatus numberString:viewModel.likeCount];

    _contentLabel.text = viewModel.content;
    

    _nameLabel.text = viewModel.username;
    _timeLabel.text = viewModel.publishTime;
    
    

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

- (void)addKVO {
    [_vm addObserver:self forKeyPath:@"loveStatus" options:NSKeyValueObservingOptionNew context:NULL];
    [_vm addObserver:self forKeyPath:@"likeCount" options:NSKeyValueObservingOptionNew context:NULL];
    [_vm addObserver:self forKeyPath:@"shareCount" options:NSKeyValueObservingOptionNew context:NULL];
    [_vm addObserver:self forKeyPath:@"commentCount" options:NSKeyValueObservingOptionNew context:NULL];

}
- (void)removeKVO {
    @try{
        [_vm removeObserver:self forKeyPath:@"loveStatus"];
        [_vm removeObserver:self forKeyPath:@"likeCount"];
        [_vm removeObserver:self forKeyPath:@"shareCount"];
        [_vm removeObserver:self forKeyPath:@"commentCount"];

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
    } else     if ([keyPath isEqualToString:@"shareCount"]) {
        NSString* value = [change objectForKey:@"new"];
        self.shareView.numberString = value;
    } else     if ([keyPath isEqualToString:@"commentCount"]) {
        NSString* value = [change objectForKey:@"new"];
        self.commentView.numberString = value;
    }
}

@end
