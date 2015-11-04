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
//    _imageViewArray = [NSArray arrayWithObjects:_imageView1,_imageView2,_imageView3,_imageView4, nil];
//    for (UIImageView* imageView in _imageViewArray) {
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        imageView.clipsToBounds = YES;
//    }
    _avatarButton.userInteractionEnabled = NO;
    _nameButton.userInteractionEnabled = NO;
    _followButton.userInteractionEnabled = NO;
    
    _swipeView.dataSource = self;
}

- (void)injectSauce:(PIEUserViewModel*)vm {
    _vm = vm;
    [_avatarButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:vm.avatar] placeholderImage:[UIImage imageNamed:@"cellBG"]];
    [_nameButton setTitle:vm.username forState:UIControlStateNormal];
    _countLabel.text = [NSString stringWithFormat:@"%zd 作品   %zd 粉丝   %zd 关注",vm.replyNumber,vm.fansNumber,vm.attentionNumber];
//    for (int i = 0; i<vm.replies.count; i++) {
//        DDPageVM* vm2 = [vm.replies objectAtIndex:i];
//        if (i<=3) {
//            UIImageView* imageView = [_imageViewArray objectAtIndex:i];
//            [imageView setImageWithURL:[NSURL URLWithString:vm2.imageURL] placeholderImage:[UIImage imageNamed:@"cellBG"]];
//        } else break;
//    }
    _followButton.selected = vm.followed;
    [_swipeView reloadData];
}
-(void)prepareForReuse {
    [super prepareForReuse];
//    for (int i = 0; i<4; i++) {
//        UIImageView* imageView = [_imageViewArray objectAtIndex:i];
//        imageView.image = nil;
//    }
}

#pragma mark iCarousel methods


- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //generate 100 item views
    //normally we'd use a backing array
    //as shown in the basic iOS example
    //but for this example we haven't bothered
    return MIN(_vm.replies.count, 4);
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (!view)
    {
        CGFloat width = self.swipeView.frame.size.height;
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width+10, width)];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, width, width)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 3.0;
        imageView.clipsToBounds = YES;
        [view addSubview:imageView];
    }
    DDPageVM* vm = [_vm.replies objectAtIndex:index];
    for (UIView *subView in view.subviews){
        if([subView isKindOfClass:[UIImageView class]]){
            UIImageView *imageView = (UIImageView *)subView;
            [imageView setImageWithURL:[NSURL URLWithString:vm.imageURL]];
        }
    }
    ;
    return view;
}


@end
