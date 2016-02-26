//
//  PIECarouselViewController3.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/24/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIECarouselViewController3.h"
#import "iCarousel.h"
#import "PIECarousel_ItemView_new.h"
#import "UIView+RoundedCorner.h"


#define scale_h                  (414-40)/414.0
#define kCarouselItemMaxChangedY 100
#define kDontHideDetailButton    -7

@interface PIECarouselViewController3 ()
<
    /* Protocols */
    iCarouselDelegate, iCarouselDataSource
>

@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, assign) CGFloat   carouselItemViewY;
@property (nonatomic, assign) CGPoint   originCarouselItemViewCenter;


@end

@implementation PIECarouselViewController3

#pragma mark - UI life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeAll;

    [self setupData];
    [self setupSubviews];
    [self setupGestures];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupNavBar];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}
-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}

#pragma mark - UI components setup
- (void)setupSubviews
{
    [self.view addSubview:self.carousel];
    
}

- (void)setupGestures
{
    UIPanGestureRecognizer *panOnCarousel =
    [[UIPanGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(handleGesture_pan:)];
    [self.carousel addGestureRecognizer:panOnCarousel];
    
    UITapGestureRecognizer *tapOnSelf =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnSelf:)];
    [self.view addGestureRecognizer:tapOnSelf];

}

- (void)setupNavBar
{
    
}

- (void)setupData
{
    _carouselItemViewY     = 0;
}

#pragma mark - <iCarouselDelegate>
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
            return value * 1.5f;
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

#pragma mark - <iCarouselDataSource>
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _pageVMs.count;
}

- (UIView *)carousel:(iCarousel *)carousel
  viewForItemAtIndex:(NSInteger)index reusingView:(PIECarousel_ItemView_new *)view
{
    if (view == nil) {
        CGFloat width  = SCREEN_WIDTH *scale_h;
        CGFloat height = width * (930.0 / 700);

        view= [PIECarousel_ItemView_new itemView];
        view.frame = CGRectMake(0, 0, width, height);

    }
    
    PIEPageVM* vm = [_pageVMs objectAtIndex:index];
    [view injectPageVM:vm];
    if (_hideDetailButtonIndex != kDontHideDetailButton) {
        /**
         当且仅当调用carousel的控制器有特地设置这个hideDetailIndex的时候，才需要有这一步判断
         (需求：PIEPageDetailViewController和PIECarouselViewController3的互动)
         */
        [view setShouldHideDetailButton:(index == _hideDetailButtonIndex)];
    }
    
    return view;
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    
}



#pragma mark - target-actions
- (void)handleGesture_pan:(UIPanGestureRecognizer *)panGesture
{
    iCarousel *icarousel = (iCarousel *)panGesture.view;
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        _originCarouselItemViewCenter = icarousel.currentItemView.center;
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint newCenter = icarousel.currentItemView.center;
        
        CGFloat changedY = [panGesture translationInView:self.view].y;
        newCenter.y        += changedY;
        
        _carouselItemViewY += changedY;
        
        icarousel.currentItemView.center = newCenter;
        
        // reset the translation
        [panGesture setTranslation:CGPointZero inView:self.view];
        
    }else if (panGesture.state == UIGestureRecognizerStateEnded){
        //有一个阈值
        if (fabs(_carouselItemViewY) > kCarouselItemMaxChangedY) {
            _carouselItemViewY = 0.0;
            
//            if (_carouselItemViewY > 0) {
//                // 往下弹出itemView
//                CGPoint newCenter = icarousel.currentItemView.center;
//                newCenter.y = SCREEN_HEIGHT;
//                
//                [UIView animateWithDuration:0.1
//                                 animations:^{
//                                     icarousel.currentItemView.center = newCenter;
//                                 }];
//                
//            }else{
//                // 往上弹出itemView
//                CGPoint newCenter = icarousel.currentItemView.center;
//                newCenter.y = -SCREEN_HEIGHT;
//                
//                [UIView animateWithDuration:0.1
//                                 animations:^{
//                                     icarousel.currentItemView.center = newCenter;
//                                 }];
//                
//            }
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self dismissViewControllerAnimated:YES completion:nil];
//            });
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [UIView animateWithDuration:0.3
                             animations:^{
                                 icarousel.currentItemView.center = _originCarouselItemViewCenter;
                             }];
        }
    }
    
    
}

/** Dismiss view controller while tap on the edge */

/*
    TODO: 
    1. 选对UIView加tap手势
    2. 在hitTest判断中等号右边要放那个view的实例
 
 **/

- (void)tapOnSelf:(UIGestureRecognizer*)sender {
    if ([self.view hitTest:[sender locationInView:self.view] withEvent:nil] == self.view)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Public methods
- (void)scrollToIndex:(NSInteger)index
{
    [self.carousel scrollToItemAtIndex:index animated:NO];
    
}

#pragma mark - lazy loadings

-(iCarousel *)carousel {
    if (!_carousel) {
        
        CGFloat width  = SCREEN_WIDTH *scale_h;
        CGFloat height = width * (930.0 / 700);
        _carousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-height)*0.5, self.view.frame.size.width, height)];
        _carousel.type          = iCarouselTypeLinear;
        _carousel.scrollSpeed   = 2.0;
        _carousel.delegate      = self;
        _carousel.dataSource    = self;
        _carousel.pagingEnabled = YES;
        _carousel.bounces        = YES;
//        _carousel.bounceDistance = 0.11;
//        _carousel.bounces       = NO;
    }
    return _carousel;
}


#pragma mark - Private helpers


@end
