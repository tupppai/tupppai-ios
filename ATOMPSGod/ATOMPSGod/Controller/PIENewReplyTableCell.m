//
//  PIEAskCellTableViewCell.m
//
//
//  Created by chenpeiwei on 9/11/15.
//
//

#import "PIENewReplyTableCell.h"
#import "PIEModelImage.h"
#import "POP.h"
//#import "MMPlaceHolder.h"
@interface PIENewReplyTableCell()
//@property (nonatomic, strong) UIImageView* blurView;
@end

@implementation PIENewReplyTableCell

- (void)awakeFromNib {
    // Initialization code
    [self commonInit];
//    [self showPlaceHolder];
}

- (void)commonInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;


    [_nameLabel setFont:[UIFont lightTupaiFontOfSize:13]];
    [_contentLabel setFont:[UIFont lightTupaiFontOfSize:15]];
    [_timeLabel setFont:[UIFont lightTupaiFontOfSize:10]];
    
    [_nameLabel setTextColor:[UIColor colorWithHex:0x4a4a4a andAlpha:1.0]];
    [_timeLabel setTextColor:[UIColor colorWithHex:0x4a4a4a andAlpha:0.3]];
    [_contentLabel setTextColor:[UIColor colorWithHex:0x000000 andAlpha:0.9]];
    
    _followView.contentMode = UIViewContentModeCenter;

}





-(void)prepareForReuse {
    [super prepareForReuse];
    [self.blurAnimateImageView prepareForReuse];
    [self removeKVO];
}

-(void)dealloc {
    [self removeKVO];
}



- (void)injectSauce:(PIEPageVM *)viewModel {
    _vm = viewModel;
    [self addKVO];
    NSString *urlString_avatar = [viewModel.avatarURL trimToImageWidth:_avatarView.frame.size.width*SCREEN_SCALE];
    self.blurAnimateImageView.viewModel = viewModel;
    
    _avatarView.url = urlString_avatar;
    _avatarView.isV = viewModel.isV;

    

//        if (viewModel.isMyFan) {
//            _followView.highlightedImage = [UIImage imageNamed:@"pie_mutualfollow"];
//        } else {
//            _followView.highlightedImage = [UIImage imageNamed:@"new_reply_followed"];
//        }
//        _followView.highlighted = viewModel.followed;
    
    // 需求变更
    if (viewModel.userID == [DDUserManager currentUser].uid ||
        viewModel.followed) {
        _followView.hidden = YES;
    } else {
        _followView.hidden = NO;
    }
    
    _shareView.imageView.image = [UIImage imageNamed:@"hot_share"];
    _shareView.numberString = viewModel.shareCount;
    
    _commentView.imageView.image = [UIImage imageNamed:@"hot_comment"];
    _commentView.numberString = viewModel.commentCount;


    [_likeView initStatus:viewModel.loveStatus numberString:viewModel.likeCount];
    _contentLabel.text = viewModel.content;
    
    _nameLabel.text = viewModel.username;
    _timeLabel.text = viewModel.publishTime;

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
