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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    _theImageView.contentMode = UIViewContentModeScaleAspectFill;
    _theImageView.clipsToBounds = YES;
    
    _leftThumbImageView.clipsToBounds = YES;
    _rightThumbImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configCell:(DDPageVM *)viewModel row:(NSInteger)row{
  
  if (row % 2 == 1) {
      [_rightThumbImageView mas_updateConstraints:^(MASConstraintMaker *make) {
          make.width.equalTo(@(50));
      }];
      [_leftThumbImageView mas_updateConstraints:^(MASConstraintMaker *make) {
          make.width.equalTo(@(50));
      }];

     } else  {
        //        _rightThumbImageView.image =
         [_rightThumbImageView mas_updateConstraints:^(MASConstraintMaker *make) {
             make.width.equalTo(@(100));
         }];
         [_leftThumbImageView mas_updateConstraints:^(MASConstraintMaker *make) {
             make.width.equalTo(@(0));
         }];
   
    }
    
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
    
    [super updateConstraints];
}

@end
