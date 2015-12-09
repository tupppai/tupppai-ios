//
//  PIEChannelTableViewCell.m
//  TUPAI-DEMO
//
//  Created by huangwei on 15/12/4.
//  Copyright (c) 2015年 huangwei. All rights reserved.
//

#import "PIEChannelTableViewCell.h"

@implementation PIEChannelTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    _swipeView.delegate = self;
//    _swipeView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

-(void)setVm:(PIEChannelViewModel *)vm {
    _vm = vm;
    [_imageView_banner setImageWithURL:[NSURL URLWithString:vm.imageUrl]];
}


//#pragma mark iCarousel methods
//
//
//- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
//{
//    return _vm.threads.count;
//}
//
//- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
//{
//    if (!view)
//    {
//        CGFloat width = self.swipeView.frame.size.height;
//        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width+10, width)];
//        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, width, width)];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        imageView.layer.cornerRadius = 3.0;
//        imageView.clipsToBounds = YES;
//        [view addSubview:imageView];
//    }
//    PIEPageVM* vm = [_vm.threads objectAtIndex:index];
//    for (UIView *subView in view.subviews){
//        if([subView isKindOfClass:[UIImageView class]]){
//            UIImageView *imageView = (UIImageView *)subView;
//            [imageView setImageWithURL:[NSURL URLWithString:vm.imageURL]];
//        }
//    }
//    return view;
//}

//-(void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
//    PIECarouselViewController* vc = [PIECarouselViewController new];
//    vc.pageVM = [_source objectAtIndex:index];
//    DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
//    [nav pushViewController:vc animated:YES ];
//}
//
@end
