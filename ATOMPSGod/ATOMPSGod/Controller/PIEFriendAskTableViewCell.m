//
//  PIEFriendAskTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/4/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEFriendAskTableViewCell.h"
@interface PIEFriendAskTableViewCell()
@property (strong, nonatomic) NSArray *source;

@end
@implementation PIEFriendAskTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _carousel.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//put a needle injecting into cell's ass.
- (void)injectSource:(DDPageVM*)vm {
    _timeLabel.text = vm.publishTime;
    _allWorkDescLabel.text = [NSString stringWithFormat:@"已有%@个作品",vm.totalPSNumber];
    _contentLabel.text = vm.content;
    
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
        CGFloat width = self.carousel.frame.size.height - 10;
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        view.backgroundColor = [UIColor lightGrayColor];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
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
    NSLog(@"Tapped view number: %zd", index);
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{

}
- (NSInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel {
    return 2;
}
-(UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view {
    return [UIView new];
}

@end
