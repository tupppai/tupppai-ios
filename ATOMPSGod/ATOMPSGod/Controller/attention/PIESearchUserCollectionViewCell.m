//
//  PIESearchUserCollectionViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 11/3/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIESearchUserCollectionViewCell.h"

@implementation PIESearchUserCollectionViewCell

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
- (void)addBottomBorder {
    CALayer *border = [CALayer layer];
    border.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.5].CGColor;
    border.frame = CGRectMake(0, self.frame.size.height-10, self.frame.size.width, 1);
    [self.layer addSublayer:border];
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
    _followButton.selected = vm.model.isMyFollow;
    [_swipeView reloadData];
    
}
-(void)prepareForReuse {
    [super prepareForReuse];
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
