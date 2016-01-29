//
//  PIEEliteHotReplyTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/17/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteHotReplyTableViewCell.h"
#import "PIEModelImage.h"
#import "PIECommentModel.h"
#import "FXBlurView.h"
@interface PIEEliteHotReplyTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *gapView;
//@property (nonatomic, strong) UIImageView* blurView;
@property (nonatomic,strong) MASConstraint* thumbWC;
@property (nonatomic,strong) MASConstraint* thumbHC;

/* for transmitting signal to RACSignal */
@property (nonatomic, strong) UITapGestureRecognizer *tapOnAvatar;
@property (nonatomic, strong) UITapGestureRecognizer *tapOnUsername;
@property (nonatomic, strong) UITapGestureRecognizer *tapOnFollow;
@property (nonatomic, strong) UITapGestureRecognizer *tapOnAllwork;
@property (nonatomic, strong) UITapGestureRecognizer *tapOnShare;
@property (nonatomic, strong) UITapGestureRecognizer *tapOnComment;
@property (nonatomic, strong) UITapGestureRecognizer *tapOnLike;


@end



@implementation PIEEliteHotReplyTableViewCell
- (void)awakeFromNib {
    [self commonInit];
    [self setupGesture];

}


-(void)dealloc {
    [self removeKVO];
}
- (void)commonInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    _avatarView.backgroundColor = [UIColor clearColor];

    [_nameLabel setFont:[UIFont lightTupaiFontOfSize:13]];
    [_contentLabel setFont:[UIFont lightTupaiFontOfSize:15]];
    [_commentLabel1 setFont:[UIFont lightTupaiFontOfSize:13]];
    [_commentLabel2 setFont:[UIFont lightTupaiFontOfSize:13]];
    
    [_nameLabel setTextColor:[UIColor colorWithHex:0x4a4a4a andAlpha:1.0]];
    [_contentLabel setTextColor:[UIColor colorWithHex:0x000000 andAlpha:0.9]];
    [_commentLabel1 setTextColor:[UIColor colorWithHex:0x000000 andAlpha:0.8]];
    [_commentLabel2 setTextColor:[UIColor colorWithHex:0x000000 andAlpha:0.8]];
    
    [_followView setContentMode:UIViewContentModeCenter];
    
    _commentLabel1.verticalAlignment =
    TTTAttributedLabelVerticalAlignmentTop;
    _commentLabel2.verticalAlignment =
    TTTAttributedLabelVerticalAlignmentTop;
    
    
}

- (void)setupGesture
{
    
    /* for the sake of RACSignal */
    self.tapOnAvatar = [[UITapGestureRecognizer alloc] init];
    [self.avatarView addGestureRecognizer:self.tapOnAvatar];
    self.avatarView.userInteractionEnabled = YES;
    self.avatarView.avatarImageView.userInteractionEnabled = YES;
    
    self.tapOnUsername = [[UITapGestureRecognizer alloc] init];
    [self.nameLabel addGestureRecognizer:self.tapOnUsername];
    self.nameLabel.userInteractionEnabled = YES;
    
    self.tapOnFollow = [[UITapGestureRecognizer alloc] init];
    [self.followView addGestureRecognizer:self.tapOnFollow];
    self.followView.userInteractionEnabled = YES;
    
    self.tapOnAllwork = [[UITapGestureRecognizer alloc] init];
    [self.allWorkView addGestureRecognizer:self.tapOnAllwork];
    self.allWorkView.userInteractionEnabled = YES;
    
    self.tapOnShare = [[UITapGestureRecognizer alloc] init];
    [self.shareView addGestureRecognizer:self.tapOnShare];
    self.shareView.userInteractionEnabled = YES;
    
    self.tapOnComment = [[UITapGestureRecognizer alloc] init];
    [self.commentView addGestureRecognizer:self.tapOnComment];
    self.commentView.userInteractionEnabled = YES;
    
    self.tapOnLike = [[UITapGestureRecognizer alloc] init];
    [self.likeView addGestureRecognizer:self.tapOnLike];
    self.likeView.userInteractionEnabled = YES;
    
    
}



-(void)prepareForReuse {
    [super prepareForReuse];
    [self.blurAnimateView renewContraints];
    _followView.hidden = NO;
    _commentLabel1.text = @"";
    _commentLabel2.text = @"";
    [_commentLabel1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_commentLabel2.mas_top).with.offset(0).priorityHigh();
    }];
    [_commentLabel2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_gapView.mas_top).with.offset(0).priorityHigh();
    }];
    
    [self removeKVO];
}

- (void)injectSauce:(PIEPageVM *)viewModel {
    _vm = viewModel;
    [self addKVO];
    NSString *urlString_avatar = [viewModel.avatarURL trimToImageWidth:_avatarView.frame.size.width*SCREEN_SCALE];
    NSString *urlString_imageView = [viewModel.imageURL trimToImageWidth:SCREEN_WIDTH_RESOLUTION];
    viewModel.avatarURL  = urlString_avatar;
    viewModel.imageURL = urlString_imageView;
    _blurAnimateView.viewModel = viewModel;

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
    _shareView.numberString = viewModel.shareCount;
    
    _commentView.imageView.image = [UIImage imageNamed:@"hot_comment"];
    _commentView.numberString = viewModel.commentCount;
    [_likeView initStatus:viewModel.loveStatus numberString:viewModel.likeCount];
    _contentLabel.text = viewModel.content;
    
    _avatarView.url = urlString_avatar;
    _avatarView.isV = viewModel.isV;
    
    _nameLabel.text = viewModel.username;

    
    if (viewModel.model.models_comment.count > 0) {
    
        _commentIndeicatorImageView.hidden = NO;
        PIECommentModel* commentEntity1  = viewModel.model.models_comment[0];
        _commentLabel1.text = [NSString stringWithFormat:@"%@: %@",commentEntity1.nickname,commentEntity1.content];
       
        [_commentLabel2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_gapView.mas_top).with.offset(-25).with.priorityHigh();
        }];
        
        if (viewModel.model.models_comment.count > 1) {
            
            [_commentLabel1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_commentLabel2.mas_top).with.offset(-10).with.priorityHigh();
            }];
            
            PIECommentModel* commentEntity2  = viewModel.model.models_comment[1];
            _commentLabel2.text = [NSString stringWithFormat:@"%@: %@",commentEntity2.nickname,commentEntity2.content];
        }
    }
    else {
        _commentIndeicatorImageView.hidden = YES;
    }
    
    
}


- (void)addKVO {
    [_vm addObserver:self forKeyPath:@"loveStatus" options:NSKeyValueObservingOptionNew context:NULL];
    [_vm addObserver:self forKeyPath:@"likeCount" options:NSKeyValueObservingOptionNew context:NULL];
    [_vm addObserver:self forKeyPath:@"followed" options:NSKeyValueObservingOptionNew context:NULL];
    [_vm addObserver:self forKeyPath:@"shareCount" options:NSKeyValueObservingOptionNew context:NULL];
    [_vm addObserver:self forKeyPath:@"commentCount" options:NSKeyValueObservingOptionNew context:NULL];
}
- (void)removeKVO {
    @try{
        [_vm removeObserver:self forKeyPath:@"loveStatus"];
        [_vm removeObserver:self forKeyPath:@"likeCount"];
        [_vm removeObserver:self forKeyPath:@"followed"];
        [_vm removeObserver:self forKeyPath:@"shareCount"];
        [_vm removeObserver:self forKeyPath:@"commentCount"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
}
- (void)animateWithType:(PIEThumbAnimateViewType)type {
    [self.blurAnimateView animateWithType:type];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loveStatus"]) {
        NSInteger newLovedCount = [[change objectForKey:@"new"]integerValue];
        self.likeView.status = newLovedCount;
    } else     if ([keyPath isEqualToString:@"likeCount"]) {
        NSInteger newLikeCount = [[change objectForKey:@"new"]integerValue];
        self.likeView.number = newLikeCount;
    } else     if ([keyPath isEqualToString:@"followed"]) {
        BOOL newFollowed = [[change objectForKey:@"new"]boolValue];
        self.followView.highlighted = newFollowed;
    } else     if ([keyPath isEqualToString:@"shareCount"]) {
        NSString* value = [change objectForKey:@"new"];
        self.shareView.numberString = value;
    } else     if ([keyPath isEqualToString:@"commentCount"]) {
        NSString* value = [change objectForKey:@"new"];
        self.commentView.numberString = value;
    }
}

#pragma mark - public RAC signal

- (RACSignal *)tapOnAvatarOrUsernameSignal{
    if (_tapOnAvatarOrUsernameSignal == nil) {
        RACSignal *tapOnAvatarSignal = [self.tapOnAvatar rac_gestureSignal];
        RACSignal *tapOnUsernameSignal = [self.tapOnUsername rac_gestureSignal];
        
        _tapOnAvatarOrUsernameSignal =
        [[RACSignal merge:@[tapOnAvatarSignal, tapOnUsernameSignal]]
         takeUntil:self.rac_prepareForReuseSignal];
    }
    
    return _tapOnAvatarOrUsernameSignal;
}

- (RACSignal *)tapOnFollowButtonSignal
{
    if (_tapOnFollowButtonSignal == nil) {
        _tapOnFollowButtonSignal = [[self.tapOnFollow rac_gestureSignal]
                                    takeUntil:self.rac_prepareForReuseSignal];
    }
    
    return _tapOnFollowButtonSignal;
}


- (RACSignal *)tapOnAllWorkSignal
{
    if (_tapOnAllWorkSignal == nil) {
        _tapOnAllWorkSignal = [[self.tapOnAllwork rac_gestureSignal]
                               takeUntil:self.rac_prepareForReuseSignal];
    }
    
    return _tapOnAllWorkSignal;
}

- (RACSignal *)tapOnCommentSignal
{
    if (_tapOnCommentSignal == nil) {
        _tapOnCommentSignal = [[self.tapOnComment rac_gestureSignal]
                               takeUntil:self.rac_prepareForReuseSignal];
    }
    
    return _tapOnCommentSignal;
}


- (RACSignal *)tapOnShareSignal
{
    if (_tapOnShareSignal == nil) {
        _tapOnShareSignal = [[self.tapOnShare rac_gestureSignal]
                             takeUntil:self.rac_prepareForReuseSignal];
    }
    
    return _tapOnShareSignal;
}

- (RACSignal *)tapOnLikeSignal
{
    if (_tapOnLikeSignal == nil) {
        _tapOnLikeSignal = [[self.tapOnLike rac_gestureSignal]
                            takeUntil:self.rac_prepareForReuseSignal];
    }
    
    return _tapOnLikeSignal;
}

@end