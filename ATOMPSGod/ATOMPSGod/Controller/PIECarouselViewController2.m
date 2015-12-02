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
#import "JGActionSheet.h"
#import "PIECarousel_ItemView.h"
#import "DDNavigationController.h"
#import "PIECommentViewController2.h"


@interface PIECarouselViewController2 ()<JGActionSheetDelegate>
@property (nonatomic, strong)  iCarousel *carousel;


//@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) PIEPageVM* currentVM;
@property (nonatomic, strong)  JGActionSheet * psActionSheet;
@property (nonatomic, assign)  NSInteger askCount;
@property (nonatomic, assign)  NSInteger replyCount;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *bottomDimmerView;
@property (nonatomic, assign) NSInteger previousCurrentIndex ;

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
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
//    [self.carousel addGestureRecognizer:pan];
}

CGFloat startPanLocationY;

- (void)pan:(UIPanGestureRecognizer *)sender
{
    if ( sender.state == UIGestureRecognizerStateBegan) {
        startPanLocationY = [sender locationInView:self.carousel].y;
    }
    
    CGRect frame = self.carousel.currentItemView.frame;
    frame.origin.y += [sender locationInView:self.carousel].y - startPanLocationY;
    self.carousel.currentItemView.frame = frame;
    startPanLocationY = [sender locationInView:self.view].y;
}


- (void)handleGesture_SwipeUp:(id)sender {
    PIECommentViewController2* vc = [PIECommentViewController2 new];
    vc.vm = _currentVM;
    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    DDNavigationController* nav = [[DDNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)handleGesture_SwipeDown:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(iCarousel *)carousel {
    if (!_carousel) {
        _carousel = [[iCarousel alloc]initWithFrame:self.view.bounds];
        _carousel.type = iCarouselTypeCoverFlow2;
        _carousel.backgroundColor = [UIColor clearColor];
        _carousel.delegate = self;
        _carousel.dataSource = self;
        _carousel.pagingEnabled = YES;
        _carousel.bounces = YES;
        _carousel.bounceDistance = 0.21;
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
        if (view == nil)
        {
            
            CGFloat scale_h = (414-40)/414.0;
            CGFloat scale_v = (736-94)/736.0;
            
            CGFloat width  = SCREEN_WIDTH *scale_h;
            CGFloat height = SCREEN_HEIGHT*scale_v;
            
//            CGFloat margin_h = (SCREEN_WIDTH - width)/2.0;
            CGFloat margin_v = (SCREEN_HEIGHT - height);
            
            view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, self.view.bounds.size.height)];
            view.backgroundColor = [UIColor clearColor];

            PIECarousel_ItemView* itemView = [[PIECarousel_ItemView alloc]initWithFrame:CGRectMake(0, margin_v, width, view.frame.size.height)];
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
            [_carousel reloadData];
            [self reorderSourceAndScroll];
        
    }];
}


- (void)flyCurrentItemViewWithDirection:(BOOL)up {
    
//    if (up && self.carousel.currentItemView.tag!=1) {
//        CGRect frame =  self.carousel.currentItemView.frame;
//        frame.origin.y = frame.origin.y - 10;
//        self.carousel.currentItemView.tag = 1;
//
//        [UIView animateWithDuration:0.3 animations:^{
//            self.carousel.currentItemView.frame = frame;
//        }completion:^(BOOL finished) {
//            if (finished) {
//            }
//        }];
//    } else if (!up && self.carousel.currentItemView.tag!=0) {
//        CGRect frame =  self.carousel.currentItemView.frame;
//        frame.origin.y = frame.origin.y + 10;
//        self.carousel.currentItemView.tag = 0;
//        
//        [UIView animateWithDuration:0.2 animations:^{
//            self.carousel.currentItemView.frame = frame;
//        }completion:^(BOOL finished) {
//            if (finished) {
//            }
//        }];
//    
//    }
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
                    [_carousel scrollToItemAtIndex:2 duration:0];
                }
                else {
                    [_dataSource insertObject:vm atIndex:1];
                    [_carousel reloadData];
                    [_carousel scrollToItemAtIndex:1 duration:0];
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
        [_carousel scrollToItemAtIndex:0 duration:0];

//        [self updateUIWithIndex:0];
    }

}



- (JGActionSheet *)psActionSheet {
    WS(ws);
    if (!_psActionSheet) {
        _psActionSheet = [JGActionSheet new];
        JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"下载图片帮P", @"添加至进行中",@"取消"] buttonStyle:JGActionSheetButtonStyleDefault];
        [section setButtonStyle:JGActionSheetButtonStyleCancel forButtonAtIndex:2];
        NSArray *sections = @[section];
        _psActionSheet = [JGActionSheet actionSheetWithSections:sections];
        _psActionSheet.delegate = self;
        [_psActionSheet setOutsidePressBlock:^(JGActionSheet *sheet) {
            [sheet dismissAnimated:YES];
        }];
        [_psActionSheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            switch (indexPath.row) {
                case 0:
                    [ws.psActionSheet dismissAnimated:YES];
                    [ws help:YES];
                    break;
                case 1:
                    [ws.psActionSheet dismissAnimated:YES];
                    [ws help:NO];
                    break;
                case 2:
                    [ws.psActionSheet dismissAnimated:YES];
                    break;
                default:
                    [ws.psActionSheet dismissAnimated:YES];
                    break;
            }
        }];
    }
    return _psActionSheet;
}

- (void)help:(BOOL)shouldDownload {
    NSMutableDictionary* param = [NSMutableDictionary new];
    [param setObject:@"ask" forKey:@"type"];
    [param setObject:@(_currentVM.askID) forKey:@"target"];
    
    [DDService signProceeding:param withBlock:^(NSString *imageUrl) {
        if (imageUrl != nil) {
            if (shouldDownload) {
                [DDService downloadImage:imageUrl withBlock:^(UIImage *image) {

                    UIImageWriteToSavedPhotosAlbum(image,self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                }];
            }
            else {
                [Hud customText:@"添加成功\n在“进行中”等你下载咯!" inView:self.view];
            }
        }
    }];
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
  contextInfo: (void *) contextInfo {
    if(error != NULL){
    } else {
        [Hud customText:@"下载成功\n我猜你会用美图秀秀来P?" inView:self.view];
    }
}
@end
