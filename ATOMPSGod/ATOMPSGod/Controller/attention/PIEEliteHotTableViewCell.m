//
//  PIEFollowHotTableViewCell.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/20/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteHotTableViewCell.h"
#import "PIEImageEntity.h"

@implementation PIEEliteHotTableViewCell
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
}


- (void)initThumbAnimateView {
    _thumbView = [PIEThumbAnimateView new];
    [self insertSubview:_thumbView aboveSubview:_theImageView];
    [self bringSubviewToFront:_thumbView];
    [_thumbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@100);
        make.trailing.equalTo(_theImageView);
        make.bottom.equalTo(_theImageView);
    }];
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
        _likeView.hidden = NO;
        _bangView.hidden = YES;
        [self initThumbAnimateView];
        _thumbView.expandedSize = CGSizeMake(SCREEN_WIDTH, imageViewHeight);
        _thumbView.subviewCounts = viewModel.askImageModelArray.count;
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
        _likeView.hidden = YES;
        _bangView.hidden = NO;
        [self.contentView addSubview:self.bangView];
        [self mansoryBangView];
    }
}

- (void)mansoryBangView {
    [self.bangView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@24);
        make.height.equalTo(@30);
        make.right.equalTo(self.contentView.mas_right).with.offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-2);
    }];
}
-(PIEBangView *)bangView {
    if (!_bangView) {
        _bangView = [[PIEBangView alloc]init];
    }
    return _bangView;
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
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        _thumbView.toExpand = !_thumbView.toExpand;
    }];
}


@end
