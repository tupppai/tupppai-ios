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
    _avatarButton.layer.cornerRadius = _avatarButton.frame.size.width/2;
    _avatarButton.clipsToBounds = YES;
    _avatarButton.backgroundColor = [UIColor lightGrayColor];
    _countLabel.textColor = [UIColor colorWithHex:0x4a4a4a andAlpha:0.8];
    _followButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _nameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _avatarButton.userInteractionEnabled = NO;
    _nameButton.userInteractionEnabled = NO;
    _followButton.userInteractionEnabled = NO;
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
    [_avatarButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:vm.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    [_nameButton setTitle:vm.username forState:UIControlStateNormal];
    _countLabel.text = [NSString stringWithFormat:@"%zd 作品   %zd 粉丝   %zd 关注",vm.replyNumber,vm.fansNumber,vm.attentionNumber];
    _followButton.selected = vm.followed;
    [_swipeView reloadData];
}
-(void)prepareForReuse {
    [super prepareForReuse];
}

#pragma mark iCarousel methods


- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return MIN(_vm.replies.count, 4);
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
        imageView.layer.cornerRadius = 3.0;
        imageView.clipsToBounds = YES;
        [view addSubview:imageView];
    }
    PIEPageVM* vm = [_vm.replies objectAtIndex:index];
    for (UIView *subView in view.subviews){
        if([subView isKindOfClass:[UIImageView class]]){
            UIImageView *imageView = (UIImageView *)subView;
            [imageView sd_setImageWithURL:[NSURL URLWithString:vm.imageURL]];
        }
    }
    return view;
}


@end
