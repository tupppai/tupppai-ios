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

@end
@implementation PIEFriendAskTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.bounces = YES;
    _carousel.bounceDistance = 1;
    _carousel.contentOffset = CGSizeMake((-SCREEN_WIDTH+ self.carousel.frame.size.height + 30) /2, 0);
    _carousel.centerItemWhenSelected = NO;
    _carousel.clipsToBounds = YES;
    _source = [NSMutableArray new];
    
    _contentLabel.textColor = [UIColor colorWithHex:0x50484B andAlpha:1];
    _allWorkDescLabel.textColor = [UIColor colorWithHex:0xFEAA2B andAlpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//put a needle injecting into cell's ass.
- (void)injectSource:(NSArray*)array {
    [_source removeAllObjects];
    for (PIEPageEntity* entity in array) {
        [_source addObject:[[DDPageVM alloc]initWithPageEntity:entity]];
    }
    DDPageVM* vm = [_source objectAtIndex:0];
    _timeLabel.text = vm.publishTime;
    _allWorkDescLabel.text = [NSString stringWithFormat:@"已有%@个作品",vm.totalPSNumber];
    _contentLabel.text = [NSString stringWithFormat:@"要求:%@",vm.content];
    [self.carousel reloadData];
}

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return _source.count;
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    DDPageVM* vm = [_source objectAtIndex:index];
    //create new view if no view is available for recycling
    if (view == nil)
    {
        CGFloat width = self.carousel.frame.size.height;
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        view.backgroundColor = [UIColor lightGrayColor];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.layer.cornerRadius = 3.0;
        view.clipsToBounds = YES;
        if (vm.type == PIEPageTypeAsk) {
            UIImageView* originView = [[UIImageView alloc]initWithFrame:CGRectMake(-4, 0, 37, 16)];
            originView.image = [UIImage imageNamed:@"pie_origin"];
            originView.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:originView];
        }
    }
    [((UIImageView *)view) setImageWithURL:[NSURL URLWithString:vm.imageURL]];
    return view;
}


- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.1f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    PIECarouselViewController* vc = [PIECarouselViewController new];
    vc.pageVM = [_source objectAtIndex:index];
    DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
    [nav pushViewController:vc animated:YES ];
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    
}


@end
