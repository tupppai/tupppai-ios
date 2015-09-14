//
//  PIEAskCellTableViewCell.m
//  
//
//  Created by chenpeiwei on 9/11/15.
//
//

#import "PIEHotTableCell.h"
@interface PIEHotTableCell()

@end

@implementation PIEHotTableCell

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
}
- (void)initThumbAnimateView {
    _thumbView = [PIEThumbAnimateView new];
    [self insertSubview:_thumbView aboveSubview:_theImageView];
    [self bringSubviewToFront:_thumbView];
    [_thumbView mas_remakeConstraints:^(MASConstraintMaker *make) {
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
    [_theImageView setImageWithURL:[NSURL URLWithString:viewModel.imageURL] placeholderImage:[UIImage imageNamed:@"placeholderImage_1"]];
    CGFloat imageViewHeight = viewModel.height <= SCREEN_HEIGHT/2 ? viewModel.height : SCREEN_HEIGHT/2;
    [_theImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(imageViewHeight)).with.priorityHigh();
    }];

    _shareCountLabel.text = viewModel.shareCount;
    _collectCountLabel.text = @"404";
    _commentCountLabel.text = viewModel.commentNumber;
    _likeCountLabel.text = viewModel.likeCount;
    _likeView.highlighted = viewModel.liked;
    
    _thumbView.expandedSize = CGSizeMake(SCREEN_WIDTH, imageViewHeight);
    if (row % 2 == 1) {
        _thumbView.subviewCounts = 2;
    } else  {
        _thumbView.subviewCounts = 1;
    }
}

-(void)prepareForReuse {
    [super prepareForReuse];
    [_thumbView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@100);
        make.trailing.equalTo(_theImageView);
        make.bottom.equalTo(_theImageView);
    }];

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
    [UIView animateWithDuration:0.8 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        _thumbView.toExpand = !_thumbView.toExpand;
    }];
}
@end
