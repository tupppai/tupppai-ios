//
//  PIEDetailPageVC.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/8/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIECarouselViewController.h"
#import "DDHotDetailManager.h"
#import "PIEFriendViewController.h"
#import "HMSegmentedControl.h"
#import "UIImage+Blurring.h"


@interface PIECarouselViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *blurView;
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) DDPageVM* currentVM;
@property (nonatomic, strong) HMSegmentedControl* segmentedControl;

@end

@implementation PIECarouselViewController
-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
-(void)awakeFromNib {
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.titleView = self.segmentedControl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBlurredImage];
    [self getDataSource];
    [self setupViews];
}
- (void)setupViews {
    self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;
    _carousel.type = iCarouselTypeLinear;
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.pagingEnabled = YES;
    _carousel.bounces = YES;
    _carousel.bounceDistance = 0.21;
    
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    [_likeButton setImage:[UIImage imageNamed:@"pie_like_selected"] forState:UIControlStateSelected];
    [_likeButton setImage:[UIImage imageNamed:@"pie_like_selected"] forState:UIControlStateHighlighted];
    _blurView.alpha = 0.3;
    _avatarView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapG1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToSeeFriend)];
    [_avatarView addGestureRecognizer:tapG1];
    _usernameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapG2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToSeeFriend)];
    [_usernameLabel addGestureRecognizer:tapG2];
}
- (void)pushToSeeFriend {
    PIEFriendViewController * friendVC = [PIEFriendViewController new];
    friendVC.pageVM = _currentVM;
    [self.navigationController pushViewController:friendVC animated:YES];
}
- (IBAction)tapLikeButton:(id)sender {
    _likeButton.selected = !_likeButton.selected;
    [_likeButton scaleAnimation];
    [DDService toggleLike:_likeButton.selected ID:_currentVM.ID type:_currentVM.type  withBlock:^(BOOL success) {
        if (success) {
            _pageVM.liked = _likeButton.selected;
        } else {
            NSLog(@"return error");
            _likeButton.selected = !_likeButton.selected;
        }
    }];
}

- (void)setupBlurredImage
{
    UIImage *theImage = _pageVM.image? :[UIImage imageNamed:@"psps"];
    
    self.blurView.image = [theImage gaussianBlurWithBias:1000];
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
        DDPageVM* vm = [_dataSource objectAtIndex:index];
        //create new view if no view is available for recycling
        if (view == nil)
        {
            CGFloat height = self.carousel.frame.size.height-80;
            CGFloat width = MAX(height*vm.imageWidth/vm.imageHeight, 200);
            width = MIN(width, SCREEN_WIDTH - 80);
            view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height, height)];
            view.backgroundColor = [UIColor clearColor];
            view.contentMode = UIViewContentModeScaleAspectFit;
            view.clipsToBounds = YES;
        }
        [((UIImageView *)view) setImageWithURL:[NSURL URLWithString:vm.imageURL]];
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
            return value * 1.03f;
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
    [self updateUIWithIndex:carousel.currentItemIndex];
    [self.segmentedControl setSelectedSegmentIndex:carousel.currentItemIndex animated:YES];
}
- (NSInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel {
    return 2;
}
-(UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view {
    return [UIView new];
}

-(void)updateUIWithIndex:(NSInteger)index {
    if (_dataSource.count > index) {
        _currentVM = [_dataSource objectAtIndex:index];
        [_avatarView setImageWithURL:[NSURL URLWithString:_currentVM.avatarURL] placeholderImage:[UIImage new]];
        _usernameLabel.text = _currentVM.username;
        _timeLabel.text = _currentVM.publishTime;
        _contentLabel.text = _currentVM.content;
        _likeButton.selected = _currentVM.liked;
    }
}
- (void)getDataSource {
    _currentPage = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(SCREEN_WIDTH - 2 * kPadding15) forKey:@"width"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(100) forKey:@"size"];
    DDHotDetailManager *manager = [DDHotDetailManager new];
    [manager fetchAllReply:param ID:_pageVM.askID withBlock:^(NSMutableArray *askArray, NSMutableArray *replyArray) {
        _dataSource = nil;
        _dataSource = [NSMutableArray array];
        for (PIEPageEntity *entity in askArray) {
            DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
            [_dataSource addObject:vm];
        }
        for (PIEPageEntity *entity in replyArray) {
            DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
            [_dataSource addObject:vm];
        }
        [self updateUIWithIndex:0];
        [self updateSegmentTitles];
        [_carousel reloadData];
        [self reorderSourceAndScroll];
    }];
}

- (void)reorderSourceAndScroll {
    for (int i =0; i < _dataSource.count; i++) {
        DDPageVM* vm = [_dataSource objectAtIndex:i];
        if (vm.ID == _pageVM.ID && vm.type == _pageVM.type && _pageVM.type == PIEPageTypeReply) {
            DDPageVM* vm2 = [_dataSource objectAtIndex:i];
            [_dataSource removeObjectAtIndex:i];
            if (_dataSource.count >= 2) {
                DDPageVM* vm3 = [_dataSource objectAtIndex:1];
                if (vm3.type == PIEPageTypeAsk) {
                    [_dataSource insertObject:vm2 atIndex:2];
                    [_carousel scrollToItemAtIndex:2 duration:0.05];
                }
                else {
                    [_dataSource insertObject:vm2 atIndex:1];
                    [_carousel scrollToItemAtIndex:1 duration:0.05];
                }
            }
            //must animate scroll carousel in order to scroll segment.
        }
    }
}
- (void)updateSegmentTitles {
    WS(ws);
    NSMutableArray* segmentDescArray = [NSMutableArray new];
    if (_pageVM.askImageModelArray.count == 1) {
        NSString* desc = @"原图";
        [segmentDescArray addObject:desc];
    }
    else {
        for (int i = 1; i<= _pageVM.askImageModelArray.count; i++) {
            NSString* desc = [NSString stringWithFormat:@"原图%d",i];
            [segmentDescArray addObject:desc];
        }
    }
    for (int i = 1; i<= _dataSource.count - _pageVM.askImageModelArray.count; i++) {
        NSString* desc = [NSString stringWithFormat:@"P%d",i];
        [segmentDescArray addObject:desc];
    }
    self.segmentedControl.sectionTitles = segmentDescArray;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [ws.carousel scrollToItemAtIndex:index animated:NO];
    }];
    [self.segmentedControl setNeedsDisplay];
}

- (HMSegmentedControl*)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"正在加载..."]];
        _segmentedControl.frame = CGRectMake(0, 120, SCREEN_WIDTH, 45);
        _segmentedControl.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor darkGrayColor], NSForegroundColorAttributeName, nil];
        _segmentedControl.selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
        _segmentedControl.selectionIndicatorHeight = 4.0f;
        _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -5, 0);
        _segmentedControl.selectionIndicatorColor = [UIColor yellowColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmentedControl.backgroundColor = [UIColor clearColor];
        
    }
    return _segmentedControl;
}

@end
