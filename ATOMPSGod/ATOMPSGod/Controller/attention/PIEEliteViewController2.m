//
//  PIEEliteViewController2.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 12/18/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteViewController2.h"
#import "HMSegmentedControl.h"
#import "PIEEliteTestVC1.h"
#import "PIEEliteTestVC2.h"
#import "PIESearchViewController.h"


/* Variables */
@interface PIEEliteViewController2 ()
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) PIEPageType currentPageType;

@property (nonatomic, strong) NSMutableArray <UIViewController *> *eliteViewControllers;


@end

/* Protocols */

@implementation PIEEliteViewController2


#pragma mark - UI life cycles

- (void)loadView
{
    [super loadView];
    
    self.view = self.scrollView;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup navigationItem
    [self setupNavigationItem];
    
    
    // setup view controllers
    [self setupViewControllers];
    
    
    
    // add view controllers as child view controllers
    [self configureViewControllers];
    
    
    
}

- (void)dealloc
{
    // remove child view controllers
    for (int i = 0; i < self.eliteViewControllers.count ; i++) {
        UIViewController *vc = self.eliteViewControllers[i];
        
        [vc willMoveToParentViewController:nil];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
}

#pragma mark - UI components setup
- (void)setupViewControllers
{
    PIEEliteTestVC1 *vc1 = [[PIEEliteTestVC1 alloc] init];
    PIEEliteTestVC2 *vc2 = [[PIEEliteTestVC2 alloc] init];
    
    [self.eliteViewControllers addObject:vc1];
    [self.eliteViewControllers addObject:vc2];
    
}

- (void)configureViewControllers
{
    // add 2 view controllers as child view controllers
    for (int i = 0; i < self.eliteViewControllers.count ; i++) {
        UIViewController *vc = self.eliteViewControllers[i];
        [self addChildViewController:vc];
        [self.scrollView addSubview:vc.view];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.scrollView);
            make.top.equalTo(self.scrollView);
            make.left.mas_equalTo(i * SCREEN_WIDTH);
        }];
        [vc didMoveToParentViewController:self];
    }
}

- (void)setupNavigationItem
{
    self.navigationItem.titleView    = self.segmentedControl;
    UIButton *backButton             =
    [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backButton
     setImage:[UIImage imageNamed:@"pie_search"] forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem =
    [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(searchBarButtonDidClick)
         forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barBackButtonItem;
}

#pragma mark - Target actions
- (void)searchBarButtonDidClick
{
    [self.navigationController
     pushViewController:[PIESearchViewController new] animated:YES];
}

#pragma mark - toggle viewController
- (void)toggleWithType:(PIEPageType)type {
    if (type == PIEPageTypeEliteFollow) {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }];
    }
    
}

#pragma mark - Lazy loadings
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        
        self.scrollView.frame                          = [UIScreen mainScreen].bounds;
        self.scrollView.showsVerticalScrollIndicator   = NO;
        self.scrollView.showsHorizontalScrollIndicator = YES;
        self.scrollView.contentSize                    = CGSizeMake(SCREEN_WIDTH * 2, 0);
        self.scrollView.pagingEnabled                  = YES;
        self.scrollView.scrollsToTop                   = NO;
        self.scrollView.backgroundColor                = [UIColor groupTableViewBackgroundColor];
    }
    
    return _scrollView;
}

-(HMSegmentedControl *)segmentedControl {
    if (_segmentedControl == nil) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"热门",@"关注"]];
        _segmentedControl.frame = CGRectMake(0, 120, 200, 45);
        _segmentedControl.titleTextAttributes =
        [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor colorWithHex:0x000000 andAlpha:0.6], NSForegroundColorAttributeName, nil];
        _segmentedControl.selectedTitleTextAttributes =
        [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
        
        _segmentedControl.selectionIndicatorHeight = 4.0f;
        _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -1, 0);
        _segmentedControl.selectionIndicatorColor = [UIColor yellowColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmentedControl.backgroundColor = [UIColor clearColor];
        
        
        __weak typeof(self) weakSelf = self;
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            
            // toggle view controllers
            if (index == 0) {
                [weakSelf toggleWithType:PIEPageTypeEliteHot];
                weakSelf.currentPageType = PIEPageTypeEliteHot;
                
                // refresh HotReply viewController if is first loaded.
                //                [ws getSourceIfEmpty_hot:nil];

            }
            else {
                [weakSelf toggleWithType:PIEPageTypeEliteFollow];
                weakSelf.currentPageType = PIEPageTypeEliteFollow;
                
                // refresh FollowReply viewController if is first loaded.
                //                [ws getSourceIfEmpty_follow:nil];
            }
        }];
        
    }
    return _segmentedControl;
}

- (NSMutableArray<UIViewController *> *)eliteViewControllers
{
    if (_eliteViewControllers == nil) {
        _eliteViewControllers = [NSMutableArray<UIViewController *> array];
    }
    
    return _eliteViewControllers;
}

@end
