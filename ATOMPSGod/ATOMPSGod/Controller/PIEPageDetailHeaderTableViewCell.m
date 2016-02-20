//
//  PIEPageDetailHeaderTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 2/19/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEPageDetailHeaderTableViewCell.h"
#import "PIEAvatarButton.h"
#import "PIEBlurAnimateImageView.h"
#import "PIEPageButton.h"
#import "PIELoveButton.h"
#import "PIEBangView.h"
#import "PIEPageCollectionSwipeView.h"
@interface PIEPageDetailHeaderTableViewCell()
@property (nonatomic,strong) PIEBangView *bangView;
@property (nonatomic,strong) PIELoveButton *loveView;
@end
@implementation PIEPageDetailHeaderTableViewCell


-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setViewModel:(PIEPageVM *)viewModel {
    _viewModel = viewModel;
    
    _shareButtonView.imageView.image   = [UIImage imageNamed:@"pieSquaredShareIcon"];

    [DDService sd_downloadImage:viewModel.avatarURL withBlock:^(UIImage *image) {
        [_avatarButton setImage:image forState:UIControlStateNormal];
        _avatarButton.isV = viewModel.isV;
    }];
    [_usernameButton setTitle:viewModel.username forState:UIControlStateNormal];
  
    _followButton.hidden = viewModel.followed;
    
    _blurAnimateImageView.viewModel = viewModel;
    _timeLabel.text = viewModel.publishTime;
    _contentLabel.text = viewModel.content;
    _shareButtonView.numberString = viewModel.shareCount;
    
    [self addTypeButton:viewModel];
    [self addPageCollectionView:viewModel];
    
}

- (void)addPageCollectionView:(PIEPageVM *)viewModel {
    if (viewModel.replyCount <= 0) {
        return;
    }
    if (viewModel.askID == 0) {
        return;
    }
    
    _pageCollectionViewHeightContraint.constant = 40;
    self.pageCollectionSwipeView.pageViewModel = viewModel;
    
    
}
- (void)addTypeButton:(PIEPageVM*)viewModel {
    if (viewModel.type == PIEPageTypeAsk) {
        [self.contentView addSubview:self.bangView];
        [self.bangView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@20);
            make.height.equalTo(@30);
            make.trailing.equalTo(self.contentView).with.offset(-10);
            make.bottom.equalTo(self.contentView).with.offset(-10);
        }];
    } else {
        [self.contentView addSubview:self.loveView];
        [self.loveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.greaterThanOrEqualTo(@20);
            make.height.equalTo(@30);
            make.trailing.equalTo(self.contentView).with.offset(-10);
            make.bottom.equalTo(self.contentView).with.offset(-10);
        }];
        self.loveView.numberString = viewModel.likeCount;
        self.loveView.status = viewModel.loveStatus;
    }
}




-(PIEBangView *)bangView {
    if (!_bangView) {
        _bangView = [PIEBangView new];
    }
    return _bangView;
}
-(PIELoveButton *)loveView {
    if (!_loveView) {
        _loveView = [PIELoveButton new];
    }
    return _loveView;
}
@end
