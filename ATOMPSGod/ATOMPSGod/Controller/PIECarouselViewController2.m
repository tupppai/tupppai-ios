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
#import "HMSegmentedControl.h"
#import "FXBlurView.h"
#import "PIECommentViewController.h"
//#import "JGActionSheet.h"
#import "PIECarousel_ItemView.h"
#import "DDNavigationController.h"
#import "PIECommentViewController2.h"
#import "PIEActionSheet_PS.h"




#define scale_h (414-40)/414.0
#define scale_v (1334-168)/1334

#define margin_v (SCREEN_HEIGHT - SCREEN_HEIGHT*scale_v)




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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupData];
    [self getDataSource];
}

-(void)setupData {
    _askCount = 0;
    _replyCount = 0;
}
-(void)setupPlaceHoder {
    CGFloat width  = SCREEN_WIDTH *scale_h;
    _view_placeHoder = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-width)/2, margin_v, width, SCREEN_HEIGHT-margin_v+5)];
    _view_placeHoder.backgroundColor = [UIColor whiteColor];
    _view_placeHoder.alpha = 0.9;
    _view_placeHoder.layer.cornerRadius = 10;
    _view_placeHoder.clipsToBounds = YES;
    [self.view addSubview:_view_placeHoder];
    
    UIActivityIndicatorView* indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.center = CGPointMake(width/2, 200);
    [_view_placeHoder addSubview:indicatorView];
    [indicatorView startAnimating];
    UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture_SwipeDown:)];
    swipe2.direction =   UISwipeGestureRecognizerDirectionDown;
    [_view_placeHoder addGestureRecognizer:swipe2];
}

- (void)setupViews {
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.8];
    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    _dataSource = [NSMutableArray array];
    [self.view addSubview:self.carousel];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture_SwipeUp:)];
    swipe.direction =   UISwipeGestureRecognizerDirectionUp;
    [self.carousel addGestureRecognizer:swipe];
    
    UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture_SwipeDown:)];
    swipe2.direction =   UISwipeGestureRecognizerDirectionDown;
    [self.carousel addGestureRecognizer:swipe2];
    UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnSelf:)];
    [self.view addGestureRecognizer:tapGes];
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
//    [self.carousel addGestureRecognizer:pan];
    [self setupPlaceHoder];
}

- (void) tapOnSelf:(UIGestureRecognizer*)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
CGFloat startPanLocationY;

//- (void)pan:(UIPanGestureRecognizer *)sender
//{
//    if ( sender.state == UIGestureRecognizerStateBegan) {
//        startPanLocationY = [sender locationInView:self.carousel].y;
//    }
//    NSLog(@"startPanLocationY%f, new y %f",startPanLocationY,[sender locationInView:self.carousel].y);
//    CGRect frame = self.carousel.currentItemView.frame;
//    frame.origin.y += [sender locationInView:self.carousel].y - startPanLocationY;
//    self.carousel.currentItemView.frame = frame;
//    startPanLocationY = [sender locationInView:self.carousel].y;
//}


- (void)handleGesture_SwipeUp:(id)sender {
    
    
    PIECommentViewController2* vc = [PIECommentViewController2 new];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.vm = _currentVM;
    DDNavigationController* nav = [[DDNavigationController alloc]initWithRootViewController:vc];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
               CGRect frame = self.carousel.currentItemView.frame;
               frame.origin.y -= margin_v - 20;
        self.carousel.currentItemView.frame = frame;
//                    [self.carousel.currentItemView setTransform:CGAffineTransformMakeScale(1.05, 1.05)];
    } completion:^(BOOL finished) {
        if (finished) {
//            [self.carousel.currentItemView setTransform:CGAffineTransformIdentity];
            [self presentViewController:nav animated:YES completion:^{
                CGRect frame = self.carousel.currentItemView.frame;
                frame.origin.y += margin_v - 20;
                self.carousel.currentItemView.frame = frame;
            }];
        }
    }];
    
    
    
}
- (void)handleGesture_SwipeDown:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];

//   [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//       CGRect frame = self.carousel.currentItemView.frame;
//       [self.carousel setTransform:CGAffineTransformMakeScale(0.3, 0.3)];
//       self.view.alpha = 0.1;
//       frame.origin.y += SCREEN_HEIGHT;
//       self.carousel.frame = frame;
//       self.view.backgroundColor = [UIColor clearColor];
//   } completion:^(BOOL finished) {
//       if (finished) {
//           [self dismissViewControllerAnimated:NO completion:nil];
//       }
//   }];
}

-(iCarousel *)carousel {
    if (!_carousel) {
        _carousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, margin_v, self.view.frame.size.width, SCREEN_HEIGHT)];
        _carousel.type = iCarouselTypeLinear;
        _carousel.backgroundColor = [UIColor clearColor];
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
//- (IBAction)tapLikeButton:(id)sender {
//    if (_currentVM.type == PIEPageTypeReply) {
//        _likeButton.selected = !_likeButton.selected;
//        [_likeButton scaleAnimation];
//        [DDService toggleLike:_likeButton.selected ID:_currentVM.ID type:_currentVM.type  withBlock:^(BOOL success) {
//            if (success) {
//                _pageVM.liked = _likeButton.selected;
//                if (_pageVM.liked) {
//                    _pageVM.likeCount = [NSString stringWithFormat:@"%zd",[_pageVM.likeCount integerValue]+1];
//                } else {
//                    _pageVM.likeCount = [NSString stringWithFormat:@"%zd",[_pageVM.likeCount integerValue]-1];
//                }
//            } else {
//                _likeButton.selected = !_likeButton.selected;
//            }
//        }];
//    }
//    else {
//        [self.psActionSheet showInView:self.view animated:YES];
//    }
//}


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
//            CGFloat height = SCREEN_HEIGHT*scale_v;
//            CGFloat margin_h = (SCREEN_WIDTH - width)/2.0;
//            CGFloat margin_v = (SCREEN_HEIGHT - height);
            
            view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, self.view.bounds.size.height)];
            view.backgroundColor = [UIColor clearColor];
        
            PIECarousel_ItemView* itemView = [[PIECarousel_ItemView alloc]initWithFrame:CGRectMake(0, 0, width, view.frame.size.height)];
            itemView.backgroundColor = [UIColor whiteColor];
            itemView.layer.cornerRadius = 10;
            itemView.clipsToBounds = YES;
            [view addSubview:itemView];
        }
        PIEPageVM* vm = [_dataSource objectAtIndex:index];
        for (id subview in view.subviews) {
            if ([subview isKindOfClass:[PIECarousel_ItemView class]]) {
                PIECarousel_ItemView* itemView = subview;
                itemView.vm = vm;
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
            return value * 1.02f;
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
    PIECommentViewController* vc = [PIECommentViewController new];
    vc.vm = _currentVM;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    [self flyCurrentItemViewWithDirection:YES];
}
- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    [self updateUIWithIndex:carousel.currentItemIndex];
}
-(void)carouselWillBeginDragging:(iCarousel *)carousel {
    [self flyCurrentItemViewWithDirection:NO];
}


- (NSInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel {
    return 2;
}
-(UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (!view) {
        view = [UIView new];
    }
    return view;
}


-(void)updateUIWithIndex:(NSInteger)index {
    if (_dataSource.count > index) {
        _currentVM = [_dataSource objectAtIndex:index];
        
//        [_avatarView setImageWithURL:[NSURL URLWithString:_currentVM.avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
// 
//        _usernameLabel.text = _currentVM.username;
//        _timeLabel.text = _currentVM.publishTime;
        
    }
}
- (void)getDataSource {
    _currentPage = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(SCREEN_WIDTH - 2 * kPadding15) forKey:@"width"];
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
//            [_carousel reloadData];
        if (self.dataSource.count > 0) {
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                _view_placeHoder.alpha = 0;
            } completion:^(BOOL finished) {
                [_view_placeHoder removeFromSuperview];
            }];
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
        if (vm.ID == _pageVM.ID && vm.type == _pageVM.type && _pageVM.type == PIEPageTypeReply) {
            if (_dataSource.count >= 2) {
                shouldScroll = YES;
                PIEPageVM* vmToCheck = [_dataSource objectAtIndex:1];
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
            //must animate scroll carousel in order to scroll segment.
        }
        //        else {
        ////            [self updateUIWithIndex:0];
        //            [_carousel.delegate carouselCurrentItemIndexDidChange:_carousel];
        //        }
    }
    if (!shouldScroll) {
        [_carousel reloadData];
//        [_carousel scrollToItemAtIndex:0 duration:0];

//        [self updateUIWithIndex:0];
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