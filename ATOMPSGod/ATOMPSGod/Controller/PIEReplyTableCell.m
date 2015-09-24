//
//  PIEAskCellTableViewCell.m
//  
//
//  Created by chenpeiwei on 9/11/15.
//
//

#import "PIEReplyTableCell.h"
#import "PIEImageEntity.h"
@interface PIEReplyTableCell()

@end

@implementation PIEReplyTableCell

- (void)awakeFromNib {
    // Initialization code
    [self commonInit];
    [self initThumbAnimateView];
}
- (void)commonInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.clipsToBounds = YES;
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    _theImageView.contentMode = UIViewContentModeScaleAspectFill;
    _theImageView.clipsToBounds = YES;
    _likeCountLabel.selected = YES;
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
- (void)configCell:(DDPageVM *)viewModel row:(NSInteger)row{
    
    
    [_avatarView setImageWithURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    _nameLabel.text = viewModel.username;
    _timeLabel.text = viewModel.publishTime;
    [_theImageView setImageWithURL:[NSURL URLWithString:viewModel.imageURL] placeholderImage:[UIImage imageNamed:@"cellBG"]];
    CGFloat imageViewHeight = viewModel.imageHeight <= SCREEN_HEIGHT/2 ? viewModel.imageHeight : SCREEN_HEIGHT/2;
    [_theImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(imageViewHeight)).with.priorityHigh();
    }];
    _shareCountLabel.text = viewModel.shareCount;
    _collectCountLabel.text = @"404";
    _commentCountLabel.text = viewModel.commentNumber;
    _likeCountLabel.text = viewModel.likeCount;
    _likeView.highlighted = viewModel.liked;
    _contentLabel.text = viewModel.content;
    _thumbView.expandedSize = CGSizeMake(SCREEN_WIDTH, imageViewHeight);
    _thumbView.subviewCounts = viewModel.askImageModelArray.count;
    PIEImageEntity* entity = viewModel.askImageModelArray[0];
    [_thumbView.rightView setImageWithURL:[NSURL URLWithString:entity.url] placeholderImage:[UIImage imageNamed:@"cellBG"]];

    if (viewModel.askImageModelArray.count == 2) {
         entity = viewModel.askImageModelArray[1];
        [_thumbView.leftView setImageWithURL:[NSURL URLWithString:entity.url] placeholderImage:[UIImage imageNamed:@"cellBG"]];

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
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        _thumbView.toExpand = !_thumbView.toExpand;
    }];
}
@end
