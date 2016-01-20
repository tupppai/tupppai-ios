//
//  PIESearchUserTableViewCell.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/17/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIESearchUserTableViewCell.h"
#import "SwipeView.h"
#import "PIEUserViewModel.h"
#import "PIEAvatarButton.h"


@interface PIESearchUserTableViewCell (SwipeView)<SwipeViewDataSource>

@end

@implementation PIESearchUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.backgroundColor = [UIColor whiteColor];
    
    _followButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _nameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_nameButton.titleLabel setFont:[UIFont lightTupaiFontOfSize:14]];
    _countLabel.font = [UIFont lightTupaiFontOfSize:11];
    [_nameButton setTitleColor:[UIColor colorWithHex:0x000000 andAlpha:0.9] forState:UIControlStateNormal];
    _countLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.8];
    _avatarButton.userInteractionEnabled = NO;
    _nameButton.userInteractionEnabled = NO;
    _followButton.userInteractionEnabled = NO;
    _avatarButton.imageView.userInteractionEnabled = YES;
    _swipeView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)injectSauce:(PIEUserViewModel*)vm {
    _vm = vm;
    
    NSString *avatar_url = [vm.avatar trimToImageWidth:_avatarButton.frame.size.width * SCREEN_SCALE];
    [DDService sd_downloadImage:avatar_url
                      withBlock:^(UIImage *image) {
                          [_avatarButton setImage:image
                                         forState:UIControlStateNormal];
                          
                      }];
    
    _avatarButton.isV = vm.model.isV;
    
    [_nameButton setTitle:vm.username forState:UIControlStateNormal];
    _countLabel.text = [NSString stringWithFormat:@"%@ 作品   %@ 粉丝   %@ 关注",vm.replyCount,vm.fansCount,vm.followCount];
    
    
    /*
     TODO: 极端情况，自己搜索自己，不要显示followButton
     */
    if (vm.model.uid == [DDUserManager currentUser].uid) {
        _followButton.hidden = YES;
    }else{
        _followButton.hidden = NO;

        /*
         TODO: 深入判断是单方面关注，还是互相关注
         */
        if (vm.model.isMyFan) {
            /* 如果对方也是我的粉丝 */
            [_followButton setImage:[UIImage imageNamed:@"pie_mutualfollow"]
                           forState:UIControlStateSelected];
        }
        
        _followButton.selected = vm.model.isMyFollow;
    }

    [_swipeView reloadData];
    
}

#pragma mark iCarousel methods
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return MIN(_vm.replyPages.count, 4);
}
- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (!view)
    {
        CGFloat width = self.swipeView.frame.size.height;
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width+10, width)];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, width, width)];
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [view addSubview:imageView];
    }
    PIEPageVM* vm = [_vm.replyPages objectAtIndex:index];
    for (UIView *subView in view.subviews){
        if([subView isKindOfClass:[UIImageView class]]){
            UIImageView *imageView = (UIImageView *)subView;
            [imageView sd_setImageWithURL:[NSURL URLWithString:vm.imageURL]];
        }
    }
    return view;
}

@end
