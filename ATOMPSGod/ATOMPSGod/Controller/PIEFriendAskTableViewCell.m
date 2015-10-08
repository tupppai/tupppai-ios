//
//  PIEFriendAskTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/4/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEFriendAskTableViewCell.h"
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
    _carousel.bounceDistance = 0.2;
    _carousel.contentOffset = CGSizeMake(-SCREEN_WIDTH/2+ 60, 0);
    _carousel.centerItemWhenSelected = NO;
    _carousel.clipsToBounds = YES;
    _source = [NSMutableArray new];
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
    _contentLabel.text = vm.content;
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
        CGFloat width = self.carousel.frame.size.height - 5;
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        view.backgroundColor = [UIColor lightGrayColor];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        if (vm.type == PIEPageTypeAsk) {
            UIImageView* originView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 27, 12)];
            originView.image = [UIImage imageNamed:@"new_reply_origin"];
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
            return value * 1.05f;
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
    DDPageVM* vm = [_source objectAtIndex:index];
    vm.image = ((UIImageView*)[carousel itemViewAtIndex:index]).image;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[_source objectAtIndex:index] forKey:@"CellVM"];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"tapCarouselItem"
     object:nil userInfo:userInfo];

}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    
}


@end
