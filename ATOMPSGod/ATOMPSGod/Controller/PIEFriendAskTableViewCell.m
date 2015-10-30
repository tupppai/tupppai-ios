//
//  PIEFriendAskTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/4/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEFriendAskTableViewCell.h"
#import "DDNavigationController.h"
#import "PIECarouselViewController.h"
#import "AppDelegate.h"

@interface PIEFriendAskTableViewCell()
@property (strong, nonatomic) NSMutableArray *source;
@property (strong, nonatomic) DDPageVM *vmAsk1;
@property (strong, nonatomic) DDPageVM *vmAsk2;

@end
@implementation PIEFriendAskTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    _swipeView.alignment = SwipeViewAlignmentEdge;
    _swipeView.dataSource = self;
    _swipeView.delegate = self;
    _swipeView.bounces = YES;
//    _swipeView.wrapEnabled = YES;
//    _swipeView.autoscroll = 0.1;
//    _swipeView.pagingEnabled = YES;
//    _swipeView.itemsPerPage = 5;
//    _swipeView.truncateFinalPage = YES;
    
    _originView1.thumbImageView.image = [UIImage imageNamed:@"pie_origin"];
    _originView2.thumbImageView.image = [UIImage imageNamed:@"pie_origin"];
    
    UITapGestureRecognizer* tapOnAsk1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnAsk1)];
    UITapGestureRecognizer* tapOnAsk2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnAsk2)];
    [self.originView1 addGestureRecognizer:tapOnAsk1];
    [self.originView2 addGestureRecognizer:tapOnAsk2];

    _contentLabel.textColor = [UIColor colorWithHex:0x50484B andAlpha:1];
    _allWorkDescLabel.textColor = [UIColor colorWithHex:0xFEAA2B andAlpha:1];
}

- (void)tapOnAsk1 {
    if (_vmAsk1) {
        PIECarouselViewController* vc = [PIECarouselViewController new];
        vc.pageVM = _vmAsk1;
        DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
        [nav pushViewController:vc animated:YES ];
    }
}
- (void)tapOnAsk2 {
    if (_vmAsk2) {
        PIECarouselViewController* vc = [PIECarouselViewController new];
        vc.pageVM = _vmAsk2;
        DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
        [nav pushViewController:vc animated:YES ];
    }
}

-(void)prepareForReuse {
    [super prepareForReuse];
    [_originView2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0);
        make.leading.equalTo(_originView1.mas_trailing).with.offset(0);
    }];
}
//put a needle injecting into cell's ass.
- (void)injectSource:(NSArray*)array {
    _source = [array mutableCopy];
    _vmAsk1 = [_source objectAtIndex:0];
    [_originView1.imageView setImageWithURL:[NSURL URLWithString:_vmAsk1.imageURL] placeholderImage:[UIImage imageNamed:@"cellBG"]];
    [_source removeObjectAtIndex:0];

    if (_source.count >= 2) {
        _vmAsk2 = [_source objectAtIndex:0];
        if (_vmAsk2.type != PIEPageTypeReply) {
            [_source removeObjectAtIndex:0];
            [_originView2.imageView setImageWithURL:[NSURL URLWithString:_vmAsk2.imageURL] placeholderImage:[UIImage imageNamed:@"cellBG"]];
            [_originView2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@84);
                make.leading.equalTo(_originView1.mas_trailing).with.offset(10);
            }];
        }
    }
    _timeLabel.text = _vmAsk1.publishTime;
    _allWorkDescLabel.text = [NSString stringWithFormat:@"已有%@个作品",_vmAsk1.totalPSNumber];
    _contentLabel.text = [NSString stringWithFormat:@"要求:%@",_vmAsk1.content];
    
    [self.swipeView reloadData];
    
}

#pragma mark iCarousel methods


- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //generate 100 item views
    //normally we'd use a backing array
    //as shown in the basic iOS example
    //but for this example we haven't bothered
    return _source.count;
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
    DDPageVM* vm = [_source objectAtIndex:index];
    for (UIView *subView in view.subviews){
        if([subView isKindOfClass:[UIImageView class]]){
            UIImageView *imageView = (UIImageView *)subView;
            [imageView setImageWithURL:[NSURL URLWithString:vm.imageURL]];
        }
    }
    ;
    return view;
}

-(void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
        PIECarouselViewController* vc = [PIECarouselViewController new];
        vc.pageVM = [_source objectAtIndex:index];
        DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
        [nav pushViewController:vc animated:YES ];
}



@end
