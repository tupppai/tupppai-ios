//
//  PIEEliteReplyTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/16/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteFollowReplyTableViewCell.h"
#import "PIEModelImage.h"
@interface PIEEliteFollowReplyTableViewCell()
//@property (nonatomic, strong) UIImageView* blurView;
@property (nonatomic, strong) UITapGestureRecognizer       *tapGesture1;
@property (nonatomic, strong) UITapGestureRecognizer       *tapGesture2;

@end

@implementation PIEEliteFollowReplyTableViewCell
- (void)awakeFromNib {
    [self commonInit];
}
-(void)dealloc {
    [self removeKVO];
}
- (void)commonInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [_nameLabel setFont:[UIFont lightTupaiFontOfSize:13]];
    [_contentLabel setFont:[UIFont lightTupaiFontOfSize:15]];
    [_timeLabel setFont:[UIFont lightTupaiFontOfSize:10]];
    
//    [_nameLabel setTextColor:[UIColor colorWithHex:0x4a4a4a andAlpha:1.0]];
//    [_contentLabel setTextColor:[UIColor colorWithHex:0x000000 andAlpha:0.9]];
//    [_timeLabel setTextColor:[UIColor colorWithHex:0x000000 andAlpha:0.3]];
    
    [_nameLabel setTextColor:[UIColor colorWithHex:0x4a4a4a]];
    [_contentLabel setTextColor:[UIColor colorWithHex:0x000000]];
    [_timeLabel setTextColor:[UIColor colorWithHex:0xB2B2B2]];
    
    _nameLabel.opaque    = YES;
    _contentLabel.opaque = YES;
    _timeLabel.opaque    = YES;
    _nameLabel.backgroundColor    = [UIColor whiteColor];
    _contentLabel.backgroundColor = [UIColor whiteColor];
    _timeLabel.backgroundColor    = [UIColor whiteColor];

    [self setupRac];

}





-(void)prepareForReuse {
    [super prepareForReuse];
    [self.animateImageView prepareForReuse];
    [self removeKVO];
}

-(void)setupRac {
    @weakify(self);
    
    self.animateImageView.thumbView.rightView.userInteractionEnabled = YES;
    self.animateImageView.thumbView.leftView.userInteractionEnabled = YES;

    _tapGesture1 = [[UITapGestureRecognizer alloc] init];
    [self.animateImageView.thumbView.leftView addGestureRecognizer:_tapGesture1];
    
    [[_tapGesture1 rac_gestureSignal]
     subscribeNext:^(id x) {
         @strongify(self);
         [self.animateImageView animateWithType:PIEThumbAnimateViewTypeLeft];
     }];
    
    _tapGesture2 = [[UITapGestureRecognizer alloc] init];
    [self.animateImageView.thumbView.rightView addGestureRecognizer:_tapGesture2];
    
    [[_tapGesture2 rac_gestureSignal]
     subscribeNext:^(id x) {
         @strongify(self);
         [self.animateImageView animateWithType:PIEThumbAnimateViewTypeRight];
     }];
}

- (void)injectSauce:(PIEPageVM *)viewModel {
    {
        _vm = viewModel;
        [self addKVO];
    }
    NSString *urlString_avatar = [viewModel.avatarURL trimToImageWidth:_avatarView.frame.size.width*SCREEN_SCALE];
    
    _animateImageView.viewModel = viewModel;
    
    [_avatarView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:urlString_avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];

    _avatarView.url = urlString_avatar;
    _avatarView.isV = viewModel.isV;
    

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
    [_vm addObserver:self forKeyPath:@"shareCount" options:NSKeyValueObservingOptionNew context:NULL];
    [_vm addObserver:self forKeyPath:@"commentCount" options:NSKeyValueObservingOptionNew context:NULL];

}
- (void)removeKVO {
    @try{
        [_vm removeObserver:self forKeyPath:@"loveStatus"];
        [_vm removeObserver:self forKeyPath:@"likeCount"];
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
    } else     if ([keyPath isEqualToString:@"shareCount"]) {
        NSString* value = [change objectForKey:@"new"];
        self.shareView.numberString = value;
    } else     if ([keyPath isEqualToString:@"commentCount"]) {
        NSString* value = [change objectForKey:@"new"];
        self.commentView.numberString = value;
    }
}

@end
