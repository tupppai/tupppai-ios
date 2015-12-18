//
//  PIEDetailPageVC.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/8/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "piecarouselViewController.h"
#import "DDHotDetailManager.h"
#import "PIEFriendViewController.h"
#import "HMSegmentedControl.h"
#import "FXBlurView.h"
#import "PIECommentViewController.h"
#import "JGActionSheet.h"
@interface piecarouselViewController ()<JGActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *blurView;
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet PIETextView_linkDetection *textView_content;

//@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) PIEPageVM* currentVM;
@property (nonatomic, strong) HMSegmentedControl* segmentedControl;
@property (nonatomic, strong)  JGActionSheet * psActionSheet;
@property (nonatomic, assign)  NSInteger askCount;
@property (nonatomic, assign)  NSInteger replyCount;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *bottomDimmerView;

@end

@implementation piecarouselViewController
-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView = self.segmentedControl;
    _likeButton.selected = _currentVM.liked;
    [MobClick beginLogPageView:@"进入滚动详情页"];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"离开滚动详情页"];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupData];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    [self addDarkEffectOnBlurView];
    [self getDataSource];
}

-(void)setupData {
    _askCount = 0;
    _replyCount = 0;
}

- (void)addDarkEffectOnBlurView {
    
        UIView* viewLayer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        viewLayer.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.2];
    
        UIView* viewLayer2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        viewLayer2.backgroundColor = [UIColor colorWithHex:0xeeeeee andAlpha:0.1];
    
        [self.blurView insertSubview:viewLayer atIndex:0];
        [self.blurView insertSubview:viewLayer2 atIndex:0];
    
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
    _avatarView.userInteractionEnabled = YES;
    _textView_content.scrollEnabled = YES;
    _dataSource = [NSMutableArray array];

    UITapGestureRecognizer *tapG1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToSeeFriend)];
    [_avatarView addGestureRecognizer:tapG1];
    _usernameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapG2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToSeeFriend)];
    [_usernameLabel addGestureRecognizer:tapG2];
    
    [_usernameLabel setFont:[UIFont lightTupaiFontOfSize:13]];
    [_timeLabel setFont:[UIFont lightTupaiFontOfSize:10]];
    [_usernameLabel setTextColor:[UIColor colorWithHex:0xffffff andAlpha:0.8]];
    [_timeLabel setTextColor:[UIColor colorWithHex:0xffffff andAlpha:0.5]];
    
    UIBlurEffect* effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _bottomDimmerView.effect = effect;
    _bottomContainerView.backgroundColor = [UIColor clearColor];
    
}
- (void)pushToSeeFriend {
    PIEFriendViewController * friendVC = [PIEFriendViewController new];
    friendVC.pageVM = _currentVM;
    [self.navigationController pushViewController:friendVC animated:YES];
}
- (IBAction)tapLikeButton:(id)sender {
    if (_currentVM.type == PIEPageTypeReply) {
        _likeButton.selected = !_likeButton.selected;
        [_likeButton scaleAnimation];
        [DDService toggleLike:_likeButton.selected ID:_currentVM.ID type:_currentVM.type  withBlock:^(BOOL success) {
            if (success) {
                _pageVM.liked = _likeButton.selected;
                if (_pageVM.liked) {
                    _pageVM.likeCount = [NSString stringWithFormat:@"%zd",[_pageVM.likeCount integerValue]+1];
                } else {
                    _pageVM.likeCount = [NSString stringWithFormat:@"%zd",[_pageVM.likeCount integerValue]-1];
                }
            } else {
                _likeButton.selected = !_likeButton.selected;
            }
        }];
    }
    else {
        [self.psActionSheet showInView:self.view animated:YES];
    }

}

- (void)DownloadAndBlurImage
{
    [DDService sd_downloadImage:_currentVM.imageURL withBlock:^(UIImage *image) {
        if (image) {
            self.blurView.image = [image blurredImageWithRadius:60 iterations:1 tintColor:[UIColor blackColor]];
        } else {
            
        }
    }];

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

        if (view == nil)
        {
            CGFloat height = self.carousel.frame.size.height-50;
            view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, height, height)];
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height, height)];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            [view addSubview:imageView];
        }
        PIEPageVM* vm = [_dataSource objectAtIndex:index];
        for (UIView *subView in view.subviews){
            if([subView isKindOfClass:[UIImageView class]]){
                UIImageView *imageView = (UIImageView *)subView;
                [imageView sd_setImageWithURL:[NSURL URLWithString:vm.imageURL]];
                break;
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
    PIECommentViewController* vc = [PIECommentViewController new];
    vc.vm = _currentVM;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    [self updateUIWithIndex:carousel.currentItemIndex];
}
- (NSInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel {
    return 2;
}
-(UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view {
    return [UIView new];
}
- (void)updateSegment:(NSInteger)index {
    //务必要_currentVM更新之后才调用此函数
    //thumbEntityArray.count 即 有count张原图
    NSMutableArray* segmentDescArray = [NSMutableArray new];
    //如果此时滚到ask
    if (_currentVM.type == PIEPageTypeAsk) {
        if (index == 1) {
            NSString* desc = @"原图(2/2)";
            [segmentDescArray addObject:desc];
        }
        else {
            if (_askCount == 1) {
                NSString* desc = @"原图";
                [segmentDescArray addObject:desc];
            }
            else {
                NSString* desc = @"原图(1/2)";
                [segmentDescArray addObject:desc];
            }
         }
        NSString* desc = [NSString stringWithFormat:@"作品(%zd)",_replyCount];
        [segmentDescArray addObject:desc];
    }
    else {
        //如果此时滚到reply
        if (_askCount == 1) {
            NSString* desc = @"原图";
            [segmentDescArray addObject:desc];
        }
        else {
            NSString* desc = @"原图(2)";
            [segmentDescArray addObject:desc];
            
            //有两张原图, index - 1 ,即目前第index-1个作品
            index = index - 1;
        }
        
        NSString* desc = [NSString stringWithFormat:@"作品(%zd/%zd)",index,_replyCount];
        [segmentDescArray addObject:desc];
    }
    
    //每一次都要更新一次
    self.segmentedControl.sectionTitles = segmentDescArray;
    [self.segmentedControl setNeedsDisplay];
    
    //让segment 随着 carousel滚动 而滚动
    if (_currentVM.type == PIEPageTypeAsk) {
        [self.segmentedControl setSelectedSegmentIndex:0 animated:YES];
    } else {
        [self.segmentedControl setSelectedSegmentIndex:1 animated:YES];
    }
    
    
}

-(void)updateUIWithIndex:(NSInteger)index {
    if (_dataSource.count > index) {
        _currentVM = [_dataSource objectAtIndex:index];
        
        [_avatarView sd_setImageWithURL:[NSURL URLWithString:_currentVM.avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
 
        _usernameLabel.text = _currentVM.username;
        _timeLabel.text = _currentVM.publishTime;
        
        UIView* currentItemView = _carousel.currentItemView;
        
        for (UIView *subView in currentItemView.subviews) {
            if([subView isKindOfClass:[UIImageView class]]){
                UIImageView *imageView = (UIImageView *)subView;
                if (imageView.image) {
                    self.blurView.image = [imageView.image blurredImageWithRadius:60 iterations:1 tintColor:[UIColor blackColor]];
                } else {
                    [self DownloadAndBlurImage];
                }
                
                break;
            }
        }

        NSString * htmlString = _currentVM.content;
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrStr.length)];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont lightTupaiFontOfSize:15] range:NSMakeRange(0, attrStr.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xffffff andAlpha:0.95] range:NSMakeRange(0, attrStr.length)];

        _textView_content.attributedText = attrStr;
        
        _likeButton.selected = _currentVM.liked;
        if (_currentVM.type == PIEPageTypeAsk) {
            [_likeButton setImage:[UIImage imageNamed:@"pie_carousel_ask"] forState:UIControlStateNormal];
            [_likeButton setImage:[UIImage imageNamed:@"pie_carousel_ask"] forState:UIControlStateHighlighted];
            [_likeButton setImage:[UIImage imageNamed:@"pie_carousel_ask"] forState:UIControlStateSelected];

        } else {
            [_likeButton setImage:[UIImage imageNamed:@"pie_like"] forState:UIControlStateNormal];
            [_likeButton setImage:[UIImage imageNamed:@"pie_like_selected"] forState:UIControlStateHighlighted];
            [_likeButton setImage:[UIImage imageNamed:@"pie_like_selected"] forState:UIControlStateSelected];

        }
        
    }
    
    [self updateSegment:index];
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
            [self initSegmentTitles];
            [self reorderSourceAndScroll];
        
    }];
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
        [self updateUIWithIndex:0];
    }
    


}
- (void)initSegmentTitles {

    WS(ws);
    NSMutableArray* segmentDescArray = [NSMutableArray new];
    if (_pageVM.thumbEntityArray.count == 1) {
        NSString* desc = @"原图";
        [segmentDescArray addObject:desc];
    }
    else {
            NSString* desc = @"原图(2)";
            [segmentDescArray addObject:desc];
    }
    
    NSString* desc = [NSString stringWithFormat:@"作品(%zd)",_dataSource.count - _pageVM.thumbEntityArray.count];
    [segmentDescArray addObject:desc];
    
    self.segmentedControl.sectionTitles = segmentDescArray;
    
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        if (index == 0) {
            [ws.carousel scrollToItemAtIndex:0 animated:NO];
        }
        else {
          
            if (_pageVM.thumbEntityArray.count >= 2 && _dataSource.count >= 3) {
                [ws.carousel scrollToItemAtIndex:2 animated:NO];
            }
            else if (_pageVM.thumbEntityArray.count == 1 && _dataSource.count >= 2){
                [ws.carousel scrollToItemAtIndex:1 animated:NO];
            }
        }
        
    }];
    [self.segmentedControl setNeedsDisplay];
}

- (HMSegmentedControl*)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"原图",@"作品"]];
        _segmentedControl.frame = CGRectMake(0, 0, 240, 45);
        _segmentedControl.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor darkGrayColor], NSForegroundColorAttributeName, nil];
        _segmentedControl.selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
        _segmentedControl.selectionIndicatorHeight = 4.0f;
        _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -1, 0);
        _segmentedControl.selectionIndicatorColor = [UIColor yellowColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmentedControl.backgroundColor = [UIColor clearColor];
        
    }
    return _segmentedControl;
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
                [DDService sd_downloadImage:imageUrl withBlock:^(UIImage *image) {

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
