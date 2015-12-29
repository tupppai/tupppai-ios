//
//  PIEEliteAskTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/16/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteFollowAskTableViewCell.h"
#import "PIEModelImage.h"
#import "FXBlurView.h"
@interface PIEEliteFollowAskTableViewCell()
@property (nonatomic, strong) UIImageView* blurView;
@end

@implementation PIEEliteFollowAskTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self commonInit];
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
    [_nameLabel setTextColor:[UIColor colorWithHex:0x4a4a4a andAlpha:1.0]];
    [_contentLabel setTextColor:[UIColor colorWithHex:0x000000 andAlpha:0.9]];
    [_timeLabel setTextColor:[UIColor colorWithHex:0x000000 andAlpha:0.3]];
    
    [_followView setContentMode:UIViewContentModeCenter];
    
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

-(void)prepareForReuse {
    [super prepareForReuse];
    _followView.hidden = NO;
}
- (void)injectSauce:(PIEPageVM *)viewModel {
    WS(ws);
    _vm = viewModel;
    NSString *urlString_avatar = [viewModel.avatarURL trimToImageWidth:_avatarView.frame.size.width*SCREEN_SCALE];
    NSString *urlString_imageView = [viewModel.imageURL trimToImageWidth:SCREEN_WIDTH_RESOLUTION];
    [_theImageView sd_setImageWithURL:[NSURL URLWithString:urlString_imageView]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                ws.theImageView.image = image;
                                ws.blurView.image = [image blurredImageWithRadius:30 iterations:1 tintColor:nil];
                            }];
//    [_avatarView.avatarImageView setImage:[UIImage imageNamed:@"avatar_default"]];
    [_avatarView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:urlString_avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    // testing
//    _avatarView.isV = YES;
//    _avatarView.isV = (viewModel.askID % 2 == 0);
//    _avatarView.isV = YES;
    _avatarView.isV = viewModel.isV;

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
    _commentView.imageView.image = [UIImage imageNamed:@"hot_comment"];
    _shareView.numberString = viewModel.shareCount;
    _commentView.numberString = viewModel.commentCount;
    _contentLabel.text = viewModel.content;
    _nameLabel.text = viewModel.username;
    _timeLabel.text = viewModel.publishTime;
 

}




@end