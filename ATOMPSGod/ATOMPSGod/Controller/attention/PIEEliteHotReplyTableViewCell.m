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


@end
@implementation PIEEliteHotReplyTableViewCell
- (void)awakeFromNib {
    [self commonInit];
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

    
    if (viewModel.models_comment.count > 0) {
    
        _commentIndeicatorImageView.hidden = NO;
        PIECommentModel* commentEntity1  = viewModel.models_comment[0];
        _commentLabel1.text = [NSString stringWithFormat:@"%@: %@",commentEntity1.nickname,commentEntity1.content];
       
        [_commentLabel2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_gapView.mas_top).with.offset(-25).with.priorityHigh();
        }];
        
        if (viewModel.models_comment.count > 1) {
            
            [_commentLabel1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_commentLabel2.mas_top).with.offset(-10).with.priorityHigh();
            }];
            
            PIECommentModel* commentEntity2  = viewModel.models_comment[1];
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
@end