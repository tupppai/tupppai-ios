//
//  PIEEliteHotAskTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/22/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteHotAskTableViewCell.h"
#import "PIEImageEntity.h"
#import "PIECommentEntity.h"

@interface PIEEliteHotAskTableViewCell()
@property (nonatomic, strong) UIImageView* blurView;
@end

@implementation PIEEliteHotAskTableViewCell


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
    _commentLabel2.text = @"";
    _commentLabel1.text = @"";
    [_commentLabel2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_gapView.mas_top).with.offset(0).priorityHigh();
    }];
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
    
    [_avatarView setImageWithURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    _nameLabel.text = viewModel.username;
    _timeLabel.text = viewModel.publishTime;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:viewModel.imageURL]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [_theImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"cellBG"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        ws.theImageView.image = image;
        ws.blurView.image = [image blurredImageWithRadius:30 iterations:1 tintColor:nil];
    } failure:nil];
    
//    CGFloat imageViewHeight = viewModel.imageHeight <= SCREEN_HEIGHT/2 ? viewModel.imageHeight : SCREEN_HEIGHT/2;
//    imageViewHeight = MAX(200, imageViewHeight);
    [_theImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(SCREEN_WIDTH)).with.priorityHigh();
    }];
    
    if (viewModel.hotCommentEntityArray.count > 0) {
        PIECommentEntity* commentEntity1  = viewModel.hotCommentEntityArray[0];
        _commentLabel1.text = [NSString stringWithFormat:@"%@: %@",commentEntity1.nickname,commentEntity1.content];
        
        if (viewModel.hotCommentEntityArray.count == 1) {
            //            [_commentLabel1 mas_updateConstraints:^(MASConstraintMaker *make) {
            //                make.bottom.equalTo(_commentLabel2.mas_top).with.offset(-14).with.priorityHigh();
            //            }];
        } else {
            PIECommentEntity* commentEntity2  = viewModel.hotCommentEntityArray[1];
            _commentLabel2.text = [NSString stringWithFormat:@"%@: %@",commentEntity2.nickname,commentEntity2.content];
            [_commentLabel2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_gapView.mas_top).with.offset(-14).with.priorityHigh();
            }];
        }
    }
    
    if (viewModel.userID == [DDUserManager currentUser].uid) {
        _followView.hidden = YES;
    }
}
@end
