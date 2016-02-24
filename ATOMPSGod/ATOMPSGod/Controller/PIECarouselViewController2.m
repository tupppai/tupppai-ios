//
//  PIEDetailPageVC.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/8/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIECarouselViewController2.h"
#import "DDHotDetailManager.h"
#import "PIEFriendViewController.h"
#import "DDNavigationController.h"
#import "PIECommentViewController.h"
#import "PIEActionSheet_PS.h"


//#import "PIECarousel_ItemView.h"
#import "PIECarousel_ItemView_new.h"
#import "UIView+RoundedCorner.h"


#define scale_h (414-40)/414.0
#define scale_v (1334-168)/1334

#define margin_v (SCREEN_HEIGHT - SCREEN_HEIGHT*scale_v)

#define kCarouselItemMaxChangedY 100

@interface PIECarouselViewController2 ()
@property (nonatomic, strong)  iCarousel *carousel;


//@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) PIEPageVM* currentVM;
@property (nonatomic, strong)  PIEActionSheet_PS * psActionSheet;
@property (nonatomic, assign)  NSInteger askCount;
@property (nonatomic, assign)  NSInteger replyCount;
//@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
//@property (weak, nonatomic) IBOutlet UIVisualEffectView *bottomDimmerView;
@property (nonatomic, assign) NSInteger previousCurrentIndex ;
@property (nonatomic, strong) UIView *view_placeHoder ;

@property (nonatomic, assign) CGFloat carouselItemViewY;
@property (nonatomic, assign) CGPoint originCarouselItemViewCenter;

@end

@implementation PIECarouselViewController2
-(instancetype)init {
    self = [super init];
    if (self) {
        [self setModalPresentationStyle:UIModalPresentationOverFullScreen];
    }
    return self;
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}
-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"进入滚动详情页"];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"离开滚动详情页"];
    self.view.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.7];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupData];
    [self getDataSource];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.7];
}
-(void)setupData {
    _askCount          = 0;
    _replyCount        = 0;
    _carouselItemViewY = 0;
}
-(void)setupPlaceHoder {
    [self.view addSubview:self.view_placeHoder];
}

-(UIView *)view_placeHoder {
    if (!_view_placeHoder) {
        CGFloat width  = SCREEN_WIDTH *scale_h;
        _view_placeHoder = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-width)/2, margin_v, width, SCREEN_HEIGHT-margin_v+5)];
        _view_placeHoder.backgroundColor = [UIColor whiteColor];
        _view_placeHoder.alpha = 0.1;
        
//        _view_placeHoder.layer.cornerRadius = 10;
//        _view_placeHoder.clipsToBounds = YES;
        
        [_view_placeHoder setRoundedCorners:UIRectCornerAllCorners radius:10];
        
        UIActivityIndicatorView* indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.center = CGPointMake(width/2, 200);
        [_view_placeHoder addSubview:indicatorView];
        [indicatorView startAnimating];
        
        UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture_SwipeDown:)];
        swipe2.direction =   UISwipeGestureRecognizerDirectionDown;
        [_view_placeHoder addGestureRecognizer:swipe2];

    }
    return _view_placeHoder;
}

- (void)setupViews {
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    _dataSource = [NSMutableArray array];
    [self.view addSubview:self.carousel];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(handleGesture_pan:)];
    [self.carousel addGestureRecognizer:pan];
    
    [self setupPlaceHoder];
}

- (void) tapOnSelf:(UIGestureRecognizer*)sender {
    
    if ([self.view hitTest:[sender locationInView:self.view] withEvent:nil] == self.view )  {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
//CGFloat startPanLocationY;


// discarded methods
/*
- (void)handleGesture_SwipeUp:(id)sender {
    
    
    PIECommentViewController* vc = [PIECommentViewController new];
    vc.vm = _currentVM;
    vc.shouldShowHeaderView = YES;
//    [vc loadViewIfNeeded];
    DDNavigationController* nav = [[DDNavigationController alloc]initWithRootViewController:vc];
    nav.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = self.carousel.currentItemView.frame;
    frame.origin.y = + (6);
    
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.view.backgroundColor = [UIColor whiteColor];
        self.carousel.currentItemView.frame = frame;
        self.carousel.currentItemView.transform =
        CGAffineTransformMakeScale(SCREEN_WIDTH/self.carousel.currentItemView.frame.size.width, SCREEN_WIDTH/self.carousel.currentItemView.frame.size.width);

        self.carousel.currentItemView.layer.cornerRadius = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:nav animated:NO completion:^{
                self.carousel.currentItemView.transform = CGAffineTransformIdentity;
                CGRect frame = self.carousel.currentItemView.frame;
                frame.origin.y = -6;
                self.carousel.currentItemView.frame = frame;
                self.view.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.7];
            }];
        });
    } completion:^(BOOL finished) {
        
    }];

} */

- (void)handleGesture_SwipeDown:(id)sender {

   [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
       CGRect frame = self.carousel.currentItemView.frame;
       frame.origin.y += 20;
       self.carousel.currentItemView.frame = frame;
       self.view.backgroundColor = [UIColor clearColor];
   } completion:^(BOOL finished) {
       if (finished) {
           [self dismissViewControllerAnimated:NO completion:nil];
       }
   }];
}


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
            
            if (_carouselItemViewY > 0) {
                // 往下弹出itemView
                CGPoint newCenter = icarousel.currentItemView.center;
                newCenter.y = SCREEN_HEIGHT;
                
                [UIView animateWithDuration:0.1
                                 animations:^{
                                     icarousel.currentItemView.center = newCenter;
                                 }];
                
            }else{
                // 往上弹出itemView
                CGPoint newCenter = icarousel.currentItemView.center;
                newCenter.y = -SCREEN_HEIGHT;
                
                [UIView animateWithDuration:0.1
                                 animations:^{
                                     icarousel.currentItemView.center = newCenter;
                                 }];
                
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            
        }else{
            [UIView animateWithDuration:0.3
                             animations:^{
                                 icarousel.currentItemView.center = _originCarouselItemViewCenter;
                             }];
        }
    }
    
    
}

-(iCarousel *)carousel {
    if (!_carousel) {
        _carousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT)];
        _carousel.type = iCarouselTypeLinear;
//        _carousel.decelerationRate = 0.5;
        _carousel.scrollSpeed = 2.0;

//        _carousel.backgroundColor = [UIColor redColor];
        _carousel.delegate = self;
        _carousel.dataSource = self;
        _carousel.pagingEnabled = YES;
        _carousel.bounces = YES;
        _carousel.bounceDistance = 0.11;
    }
    return _carousel;
}
- (void)pushToSeeFriend {
    PIEFriendViewController * friendVC = [PIEFriendViewController new];
    friendVC.pageVM = _currentVM;
    [self.navigationController pushViewController:friendVC animated:YES];
}


#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    //must at least have 1 item so as to initalize scroll to custom index ,weird trick.
    return MAX(_dataSource.count,1);
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{

    if (_dataSource.count > index) {
        if (view == nil || view.tag != index)
        {
            view.tag = index;

            CGFloat width  = SCREEN_WIDTH *scale_h;
            CGFloat height = width * (930.0 / 700);

            view =
            [[UIView alloc]
             initWithFrame:CGRectMake(0, 0, width, height)];
            
            
//            view.backgroundColor = [UIColor clearColor];
            
//            PIECarousel_ItemView* itemView = [[PIECarousel_ItemView alloc]initWithFrame:CGRectMake(0, 0, width, view.frame.size.height)];
//            itemView.backgroundColor = [UIColor whiteColor];
//            itemView.layer.cornerRadius = 10;
//            itemView.clipsToBounds = YES;
//            [view addSubview:itemView];
            PIECarousel_ItemView_new *itemView = [PIECarousel_ItemView_new itemView];
            itemView.frame = CGRectMake(0, 0, width, height);
            [view addSubview:itemView];
        }
        PIEPageVM* vm = [_dataSource objectAtIndex:index];
        for (id subview in view.subviews) {
            if ([subview isKindOfClass:[PIECarousel_ItemView_new class]]) {
                PIECarousel_ItemView_new* itemView = subview;
                [itemView setShouldHideDetailButton:(index % 2 == 0)];
                [itemView injectPageVM:vm];
            }
        }
        return view;
    }
    return nil;
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

#pragma mark iCarousel taps

-(void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
//    [self flyCurrentItemViewWithDirection:YES];
}
- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    [self updateCurrentVMWithIndex:carousel.currentItemIndex];
}
-(void)carouselWillBeginDragging:(iCarousel *)carousel {
//    [self flyCurrentItemViewWithDirection:NO];
}

/*
//
//- (NSInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel {
//    return 2;
//}
//-(UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view {
//    if (!view) {
//        view = [UIView new];
//    }
//    return view;
//}
*/

-(void)updateCurrentVMWithIndex:(NSInteger)index {
    if (_dataSource.count > index) {
        _currentVM = [_dataSource objectAtIndex:index];
    }
}


- (void)getDataSource {
    _currentPage = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(100) forKey:@"size"];
    DDHotDetailManager *manager = [DDHotDetailManager new];
    NSInteger ID;
    if (_pageVM.askID) {
        ID = _pageVM.askID;
    } else {
        ID = _pageVM.ID;
    }
    [manager fetchAllReply:param ID:ID withBlock:^(NSMutableArray *askArray, NSMutableArray *replyArray) {
        
        _askCount = askArray.count;
        _replyCount = replyArray.count;
        
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:askArray];
        [self.dataSource addObjectsFromArray: replyArray];
        if (self.dataSource.count > 0) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                _view_placeHoder.alpha = 0;
            } completion:^(BOOL finished) {
                [_view_placeHoder removeFromSuperview];
            }];
        } else {
            _view_placeHoder.alpha = 0.6;
        }
        [self reorderSourceAndScroll];
        
    }];
}


- (void)flyCurrentItemViewWithDirection:(BOOL)up {
    
    if (up && self.carousel.currentItemView.tag!=1) {
        CGRect frame =  self.carousel.currentItemView.frame;
        frame.origin.y = frame.origin.y - 6;
        self.carousel.currentItemView.tag = 1;

        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseIn animations:^{
            self.carousel.currentItemView.frame = frame;
        } completion:nil];

    } else if (!up && self.carousel.currentItemView.tag!=0) {
        CGRect frame =  self.carousel.currentItemView.frame;
        frame.origin.y = frame.origin.y + 6;
        self.carousel.currentItemView.tag = 0;
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.carousel.currentItemView.frame = frame;
        } completion:nil];
    }
    
}
- (void)reorderSourceAndScroll {
    //初始化，把传进来的vm重组，放在原图的下一位，被滚动到此位置。
    BOOL shouldScroll = NO;
    for (int i =0; i < _dataSource.count; i++) {
        
        PIEPageVM* vm = [_dataSource objectAtIndex:i];
        //找出与传进来的pageVM匹配的vm
        
        if (vm.ID == _pageVM.ID && vm.type == _pageVM.type ) {
            //为了数据能够同步
            [_dataSource replaceObjectAtIndex:i withObject:_pageVM];

            if (_pageVM.type == PIEPageTypeReply) {
                
                if (_dataSource.count >= 2) {
                    shouldScroll = YES;
                    PIEPageVM* vmToCheck = [_dataSource objectAtIndex:1];
                    PIEPageVM* vm =[_dataSource objectAtIndex:i];
                    [_dataSource removeObjectAtIndex:i];
                    if (vmToCheck.type == PIEPageTypeAsk) {
                        [_dataSource insertObject:vm atIndex:2];
                        [_carousel reloadData];
                        [_carousel scrollToItemAtIndex:2 animated:NO];
                    }
                    else {
                        [_dataSource insertObject:vm atIndex:1];
                        [_carousel reloadData];
                        [_carousel scrollToItemAtIndex:1 animated:NO];
                    }
                    break;
                }

            }

        }
    }
    
    if (!shouldScroll) {
        [_carousel reloadData];
        [self updateCurrentVMWithIndex:0];
//        [_carousel scrollToItemAtIndex:0 duration:0];
    }

}



- (PIEActionSheet_PS *)psActionSheet {
    if (!_psActionSheet) {
        _psActionSheet = [PIEActionSheet_PS new];
        _psActionSheet.vm = _pageVM;
    }
    return _psActionSheet;
}
@end
