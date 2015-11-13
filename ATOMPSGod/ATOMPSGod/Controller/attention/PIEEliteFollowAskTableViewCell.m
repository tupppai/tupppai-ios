//
//  PIEEliteAskTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/16/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteFollowAskTableViewCell.h"
#import "PIEImageEntity.h"
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
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    _theImageView.contentMode = UIViewContentModeScaleAspectFit;
    _theImageView.clipsToBounds = YES;
    _theImageView.backgroundColor = [UIColor clearColor];
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
- (void)injectSauce:(DDPageVM *)viewModel {
    WS(ws);
    _ID = viewModel.ID;
    _askID = viewModel.askID;
    _followView.highlighted = viewModel.followed;
    _shareView.imageView.image = [UIImage imageNamed:@"hot_share"];
    _shareView.numberString = viewModel.shareCount;
    _commentView.imageView.image = [UIImage imageNamed:@"hot_comment"];
    _commentView.numberString = viewModel.commentCount;
    _contentLabel.text = viewModel.content;
    
    [_avatarView setImageWithURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _nameLabel.text = viewModel.username;
    _timeLabel.text = viewModel.publishTime;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:viewModel.imageURL]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [_theImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"cellBG"] success:^(NSURLRequest *  request, NSHTTPURLResponse *  response, UIImage *  image) {
        ws.theImageView.image = image;
        ws.blurView.image = [image blurredImageWithRadius:30 iterations:1 tintColor:nil];
    } failure:nil];
//    CGFloat imageViewHeight = viewModel.imageHeight <= SCREEN_HEIGHT/2 ? viewModel.imageHeight : SCREEN_HEIGHT/2;
//    imageViewHeight = MAX(200, imageViewHeight);

//    [_theImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@(SCREEN_WIDTH)).with.priorityHigh();
//    }];
    

    if (viewModel.userID == [DDUserManager currentUser].uid) {
        _followView.hidden = YES;
    }
}




@end