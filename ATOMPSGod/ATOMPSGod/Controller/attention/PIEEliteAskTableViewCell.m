//
//  PIEEliteAskTableViewCell.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/20/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteAskTableViewCell.h"
#import "PIEAvatarView.h"
#import "PIEBlurAnimateImageView.h"
#import "PIEPageButton.h"

@interface PIEEliteAskTableViewCell ()
@property (weak, nonatomic) IBOutlet PIEAvatarView           *avatarView;
@property (weak, nonatomic) IBOutlet UILabel                 *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel                 *createdTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView             *followButton;
@property (weak, nonatomic) IBOutlet PIEBlurAnimateImageView *blurAnimateImageView;
@property (weak, nonatomic) IBOutlet UILabel                 *commentLabel;
@property (weak, nonatomic) IBOutlet PIEPageButton           *shareButton;
@property (weak, nonatomic) IBOutlet PIEPageButton           *commentButton;
@property (weak, nonatomic) IBOutlet PIEPageButton           *otherWorkButton;
@property (weak, nonatomic) IBOutlet UIImageView             *bangImageView;

// Gestures for the use of RACSignal
@property (nonatomic, strong) UITapGestureRecognizer       *tapOnAvatarView;

@property (nonatomic, strong) UITapGestureRecognizer       *tapOnUsernameLabel;

@property (nonatomic, strong) UITapGestureRecognizer       *tapOnFollowButton;

@property (nonatomic, strong) UITapGestureRecognizer       *tapOnBlurAnimateImageView;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressOnBlurAnimateImageView;

@property (nonatomic, strong) UITapGestureRecognizer       *tapOnThumbImageViewLeftView;

@property (nonatomic, strong) UITapGestureRecognizer       *tapOnThumbImageViewRightView;

@property (nonatomic, strong) UITapGestureRecognizer       *tapOnShareButton;

@property (nonatomic, strong) UITapGestureRecognizer       *tapOnCommentButton;

@property (nonatomic, strong) UITapGestureRecognizer       *tapOnOtherWorkButton;

@property (nonatomic, strong) UITapGestureRecognizer       *tapOnBangImageView;



@end

@implementation PIEEliteAskTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupGestures];
    [self setupRacAction];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupGestures
{
    self.tapOnAvatarView = [[UITapGestureRecognizer alloc] init];
    [self.avatarView addGestureRecognizer:self.tapOnAvatarView];
    self.avatarView.userInteractionEnabled = YES;
    self.avatarView.avatarImageView.userInteractionEnabled = YES;
    
    self.tapOnUsernameLabel = [[UITapGestureRecognizer alloc] init];
    [self.usernameLabel addGestureRecognizer:self.tapOnUsernameLabel];
    self.usernameLabel.userInteractionEnabled = YES;
    
    self.tapOnFollowButton  = [[UITapGestureRecognizer alloc] init];
    [self.followButton addGestureRecognizer:self.tapOnFollowButton];
    self.followButton.userInteractionEnabled = YES;
    
    self.tapOnBlurAnimateImageView = [[UITapGestureRecognizer alloc] init];
    [self.blurAnimateImageView.imageView
     addGestureRecognizer:self.tapOnBlurAnimateImageView];
    
    self.blurAnimateImageView.userInteractionEnabled                         = YES;
    self.blurAnimateImageView.blurBackgroundImageView.userInteractionEnabled = YES;
    self.blurAnimateImageView.imageView.userInteractionEnabled               = YES;
    self.blurAnimateImageView.thumbView.userInteractionEnabled               = YES;
    
    self.longPressOnBlurAnimateImageView = [[UILongPressGestureRecognizer alloc] init];
    [self.blurAnimateImageView addGestureRecognizer:self.longPressOnBlurAnimateImageView];

    self.tapOnThumbImageViewLeftView = [[UITapGestureRecognizer alloc] init];
    [self.blurAnimateImageView.thumbView.leftView addGestureRecognizer:self.tapOnThumbImageViewLeftView];
    self.blurAnimateImageView.thumbView.leftView.userInteractionEnabled = YES;
    
    self.tapOnThumbImageViewRightView = [[UITapGestureRecognizer alloc] init];
    [self.blurAnimateImageView.thumbView.rightView addGestureRecognizer:self.tapOnThumbImageViewRightView];
    self.blurAnimateImageView.thumbView.rightView.userInteractionEnabled = YES;
    
    self.tapOnShareButton = [[UITapGestureRecognizer alloc] init];
    [self.shareButton addGestureRecognizer:self.tapOnShareButton];
    self.shareButton.userInteractionEnabled = YES;
    
    self.tapOnCommentButton = [[UITapGestureRecognizer alloc] init];
    [self.commentButton addGestureRecognizer:self.tapOnCommentButton];
    self.commentButton.userInteractionEnabled = YES;
    
    self.tapOnOtherWorkButton = [[UITapGestureRecognizer alloc] init];
    [self.otherWorkButton addGestureRecognizer:self.tapOnOtherWorkButton];
    self.otherWorkButton.userInteractionEnabled = YES;
    
    self.tapOnBangImageView = [[UITapGestureRecognizer alloc] init];
    [self.bangImageView addGestureRecognizer:self.tapOnBangImageView];
    self.bangImageView.userInteractionEnabled = YES;
}

- (void)setupRacAction
{
    // 自己点击的放大缩小的事件就自己消化，不用在外面做一个signal
    // 因为与数据源无关，所以不用关注prepareForReuse的问题
    @weakify(self);
    [[self.tapOnThumbImageViewLeftView rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self.blurAnimateImageView animateWithType:PIEThumbAnimateViewTypeLeft];
    }];
    
    [[self.tapOnThumbImageViewRightView rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self.blurAnimateImageView animateWithType:PIEThumbAnimateViewTypeRight];
    }];
    
}

- (void)bindVM:(PIEPageVM *)pageVM
{
    // 头像
    NSString *urlString_avatar =
    [pageVM.avatarURL trimToImageWidth:_avatarView.frame.size.width * SCREEN_SCALE];
    self.avatarView.url = urlString_avatar;
    self.avatarView.isV = pageVM.isV;
    
    // 用户名
    self.usernameLabel.text    = pageVM.username;

    // 图片评论
    self.commentLabel.text = pageVM.content;
    
    // 时间
    self.createdTimeLabel.text = pageVM.publishTime;
    
    // 关注按钮
    if (pageVM.userID == [DDUserManager currentUser].uid ||
        pageVM.followed) {
        _followButton.hidden = YES;
    }else{
        _followButton.hidden = NO;
    }
    RAC(_followButton, hidden) =
    [RACObserve(pageVM, followed) takeUntil:self.rac_prepareForReuseSignal];
    
    // 图片
    _blurAnimateImageView.viewModel = pageVM;
    
    // 分享 按钮
    _shareButton.imageView.image   = [UIImage imageNamed:@"hot_share"];
    RAC(_shareButton, numberString) =
    [RACObserve(pageVM, shareCount) takeUntil:self.rac_prepareForReuseSignal];
    
    // 评论 按钮
    _commentButton.imageView.image = [UIImage imageNamed:@"hot_comment"];
    RAC(_commentButton, numberString) =
    [RACObserve(pageVM, commentCount) takeUntil:self.rac_prepareForReuseSignal];
    
    // 其他作品 按钮
    // TODO: 目前还不知道是哪个字段，先乱写一个
    _otherWorkButton.imageView.image = [UIImage imageNamed:@"otherWork_icon"];
    NSString *prompt = [NSString stringWithFormat:@"已有%@个作品", pageVM.replyCount];
    _otherWorkButton.numberString    = prompt;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.blurAnimateImageView prepareForReuse];
}

#pragma mark - public RAC signals
- (RACSignal *)tapOnUserSignal
{
    if (_tapOnUserSignal == nil) {
        RACSignal *tapOnAvatarSignal   = [self.tapOnAvatarView rac_gestureSignal];
        RACSignal *tapOnUsernameSignal = [self.tapOnUsernameLabel rac_gestureSignal];
        
        _tapOnUserSignal =
        [[RACSignal merge:@[tapOnAvatarSignal, tapOnUsernameSignal]]
         takeUntil:self.rac_prepareForReuseSignal];
    }
    return _tapOnUserSignal;
}

- (RACSignal *)tapOnFollowButtonSignal
{
    if (_tapOnFollowButtonSignal == nil) {
        _tapOnFollowButtonSignal =
        [[self.tapOnFollowButton rac_gestureSignal]
         takeUntil:self.rac_prepareForReuseSignal];
    }
    return _tapOnFollowButtonSignal;
}

- (RACSignal *)tapOnImageSignal
{
    if (_tapOnImageSignal == nil) {
        _tapOnImageSignal = [[self.tapOnBlurAnimateImageView rac_gestureSignal]
                             takeUntil:self.rac_prepareForReuseSignal];
    }
    
    return _tapOnImageSignal;
}

- (RACSignal *)longPressOnImageSignal
{
    if (_longPressOnImageSignal == nil) {
        _longPressOnImageSignal = [[self.longPressOnBlurAnimateImageView rac_gestureSignal]
                                   takeUntil:self.rac_prepareForReuseSignal];
    }
    return _longPressOnImageSignal;
}

- (RACSignal *)tapOnCommentSignal
{
    if (_tapOnCommentSignal == nil) {
        _tapOnCommentSignal =
        [[self.tapOnCommentButton rac_gestureSignal]
         takeUntil:self.rac_prepareForReuseSignal];
    }
    
    return _tapOnCommentSignal;
}

- (RACSignal *)tapOnShareSignal
{
    if (_tapOnShareSignal == nil) {
        _tapOnShareSignal = [[self.tapOnShareButton rac_gestureSignal]
                             takeUntil:self.rac_prepareForReuseSignal];
    }
    return _tapOnShareSignal;
}

- (RACSignal *)tapOnBangSignal
{
    if (_tapOnBangSignal == nil) {
        _tapOnBangSignal = [[self.tapOnBangImageView rac_gestureSignal]
                            takeUntil:self.rac_prepareForReuseSignal];
    }
    return _tapOnBangSignal;
}

- (RACSignal *)tapOnRelatedWorkSignal
{
    if (_tapOnRelatedWorkSignal == nil) {
        _tapOnRelatedWorkSignal = [[self.tapOnOtherWorkButton rac_gestureSignal]
                                   takeUntil:self.rac_prepareForReuseSignal];
    }
    
    return _tapOnRelatedWorkSignal;
}


@end
