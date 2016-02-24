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
#import "PIEShareView.h"
#import "PIEActionSheet_PS.h"

@interface PIEPageDetailHeaderTableViewCell()
@property (nonatomic,strong) PIEBangView *bangView;
@property (nonatomic,strong) PIELoveButton *loveView;
@property (weak, nonatomic) IBOutlet PIEPageButton *shareButtonView;
@property (nonatomic,strong) PIEShareView *shareView;
@property (nonatomic,strong) PIEActionSheet_PS *actionSheet_help;
@end


@implementation PIEPageDetailHeaderTableViewCell


-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)tapShare {
    [self.shareView show:self.viewModel];
}
- (void)awakeFromNib {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapShare)];
    [_shareButtonView addGestureRecognizer:tapGesture];
    _usernameButton.titleLabel.font = [UIFont lightTupaiFontOfSize:13];
    _timeLabel.font = [UIFont lightTupaiFontOfSize:10];
    _contentLabel.font = [UIFont lightTupaiFontOfSize:15];
}



-(void)setViewModel:(PIEPageVM *)viewModel {
    _viewModel = viewModel;
    
    _shareButtonView.imageView.image   = [UIImage imageNamed:@"pieSquaredShareIcon"];

    [DDService sd_downloadImage:viewModel.avatarURL withBlock:^(UIImage *image) {
        [_avatarButton setImage:image forState:UIControlStateNormal];
        _avatarButton.isV = viewModel.isV;
    }];
    [_usernameButton setTitle:viewModel.username forState:UIControlStateNormal];
    _blurAnimateImageView.hideThumbView = YES;
    _blurAnimateImageView.viewModel = viewModel;
    _timeLabel.text = viewModel.publishTime;
    _contentLabel.text = viewModel.content;
    _shareButtonView.numberString = viewModel.shareCount;
    
    [self addTypeButton:viewModel];
    [self addPageCollectionView:viewModel];
    
    RAC(_shareButtonView, numberString) =  [RACObserve(_viewModel, shareCount) takeUntil:self.rac_prepareForReuseSignal];
    RAC(_followButton, hidden) = [RACObserve(_viewModel, followed) takeUntil:self.rac_prepareForReuseSignal];

    
}

- (void)addPageCollectionView:(PIEPageVM *)viewModel {
    if (viewModel.replyCount <= 0) {
        return;
    }
    if (viewModel.askID == 0) {
        return;
    }
    
    _pageCollectionViewHeightContraint.constant = 47;
    self.pageCollectionSwipeView.pageViewModel = viewModel;
    
    
}
- (void)addTypeButton:(PIEPageVM*)viewModel {
    if (viewModel.type == PIEPageTypeAsk) {
        [self.contentView addSubview:self.bangView];
        [self.bangView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@27);
            make.height.equalTo(@33);
            make.trailing.equalTo(self.contentView).with.offset(-17);
            make.centerY.equalTo(self.shareButtonView);
        }];
    } else {
        [self.contentView addSubview:self.loveView];
        [self.loveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.greaterThanOrEqualTo(@22);
            make.height.equalTo(@19);
            make.trailing.equalTo(self.contentView).with.offset(-18);
            make.centerY.equalTo(self.shareButtonView);
        }];
        self.loveView.numberString = viewModel.likeCount;
        self.loveView.status = viewModel.loveStatus;
        
        RAC(self.loveView, status) =
        [RACObserve(_viewModel, loveStatus) takeUntil:self.rac_prepareForReuseSignal];
        RAC(self.loveView, numberString) =
        [RACObserve(_viewModel, likeCount) takeUntil:self.rac_prepareForReuseSignal];

    }
}


- (void)tapBang {
    [self.actionSheet_help showInView:[AppDelegate APP].window animated:YES];
}
- (void)tapLove {
    [self.viewModel love:NO];
}
- (void)longPressLove {
    [self.viewModel love:YES];
}
-(PIEBangView *)bangView {
    if (!_bangView) {
        _bangView = [PIEBangView new];
        _bangView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBang)];
        [_bangView addGestureRecognizer:tapGesture];
    }
    return _bangView;
}
-(PIELoveButton *)loveView {
    if (!_loveView) {
        _loveView = [PIELoveButton new];
        _loveView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLove)];
        [_loveView addGestureRecognizer:tapGesture];
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressLove)];
        [_loveView addGestureRecognizer:longPressGesture];
    }
    return _loveView;
}
-(PIEShareView *)shareView {
    if (_shareView == nil) {
        _shareView = [[PIEShareView alloc]init];
    }
    return _shareView;
}
-(PIEActionSheet_PS *)actionSheet_help {
    if (!_actionSheet_help) {
        _actionSheet_help = [PIEActionSheet_PS new];
        _actionSheet_help.vm = self.viewModel;
    }
    return _actionSheet_help;
}
@end
