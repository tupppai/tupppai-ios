//
//  PIEProceedingViewController2.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 12/23/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEProceedingViewController2.h"
#import "HMSegmentedControl.h"
#import "PIEProceedingTestVC1.h"
#import "PIEProceedingTestVC2.h"
#import "PIEProceedingToHelpViewController.h"
#import "PIEProceedingAskViewController.h"


/* Variables */
@interface PIEProceedingViewController2 ()

@property (nonatomic, strong) UIScrollView *scrollView;


@property (nonatomic, strong) NSMutableArray <UIViewController *> *proceedingViewControllers;

@end

/* Protocols */
@interface PIEProceedingViewController2 (ScrollView)
<UIScrollViewDelegate>
@end

typedef NS_ENUM(NSUInteger, PIEProceedingControllerType) {
    PIEProceedingControllerTypeToHelp,
    PIEProceedingControllerTypeAsk
};

@implementation PIEProceedingViewController2

#pragma mark - UI life cycles
- (void)loadView
{
    [super loadView];
    
    self.view = self.scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // setup navigationItem
    [self setupNavigationItem];
    
    // setup view controllers
    [self setupViewControllers];
    
    self.scrollView.contentSize =
    CGSizeMake(self.proceedingViewControllers.count * SCREEN_WIDTH, 0);
    
    // add view controllers as child view controllers
    [self configureViewControllers];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    // remove child view controllers
    for (UIViewController *vc in self.proceedingViewControllers) {
        [vc willMoveToParentViewController:nil];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
}

#pragma mark - UI components setup
- (void)setupViewControllers
{
    // create view controllers and add them to array

    PIEProceedingAskViewController *askViewController       = [PIEProceedingAskViewController new];
    PIEProceedingToHelpViewController *toHelpViewController = [PIEProceedingToHelpViewController new];
    
    [self.proceedingViewControllers addObject:askViewController];
    [self.proceedingViewControllers addObject:toHelpViewController];
}

- (void)configureViewControllers
{
    // add view controllers as child view controllers
    for (int i = 0; i < self.proceedingViewControllers.count; i++) {
        UIViewController *vc = self.proceedingViewControllers[i];
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
    // configure segmentedControl
    self.navigationItem.titleView = self.segmentedControl;
    
}

#pragma mark - Toggle view controllers
- (void)toggleViewController:(PIEProceedingControllerType)controllerType
{
    // toogle view controller by clicking the segmentedControl on the navigationBar
    if (controllerType == PIEProceedingControllerTypeAsk) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.scrollView.contentOffset = CGPointMake(0, 0);
                         }];
    }
    else if (controllerType == PIEProceedingControllerTypeToHelp){
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        }];
    }
}

#pragma mark - <UIScrollViewDelegate>
/** 滚动scrollView，改变segmentedControl上面按钮的变化 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentPage = (scrollView.contentOffset.x + CGWidth(scrollView.frame) * 0.1) / CGWidth(scrollView.frame);
    
    if (currentPage == 0) {
        [self.segmentedControl setSelectedSegmentIndex:0 animated:YES];
        // refresh if is first loaded.
    }
    else if (currentPage == 1){
        [self.segmentedControl setSelectedSegmentIndex:1 animated:YES];
        // refresh if is first loaded.
    }
}

#pragma mark - Lazy loadings
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        
        _scrollView.frame                          = [UIScreen mainScreen].bounds;
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.showsHorizontalScrollIndicator = YES;
//        _scrollView.contentSize                    = CGSizeMake(SCREEN_WIDTH * 2, 0);
        _scrollView.pagingEnabled                  = YES;
        _scrollView.scrollsToTop                   = NO;
        _scrollView.backgroundColor                = [UIColor groupTableViewBackgroundColor];
        _scrollView.delegate                       = self;
    }
    return _scrollView;
}

- (HMSegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil) {
        __weak typeof(self) weakSelf = self;
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"我的求P",@"我的帮P"]];
        _segmentedControl.frame = CGRectMake(0, 120, SCREEN_WIDTH-40, 45);
        _segmentedControl.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor colorWithHex:0x000000 andAlpha:0.6], NSForegroundColorAttributeName, nil];
        _segmentedControl.selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
        _segmentedControl.selectionIndicatorHeight = 4.0f;
        _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -1, 0);
        _segmentedControl.selectionIndicatorColor = [UIColor yellowColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            if (index == 0) {
                [weakSelf toggleViewController:PIEProceedingControllerTypeAsk];
                //                [ws getSourceIfEmpty_ask];
            } else if (index == 1) {
                [weakSelf toggleViewController:PIEProceedingControllerTypeToHelp];
                //                [ws getSourceIfEmpty_toHelp];
            }

        }];
        _segmentedControl.backgroundColor = [UIColor clearColor];
    }
    
    return _segmentedControl;
}

- (NSMutableArray<UIViewController *> *)proceedingViewControllers
{
    if (_proceedingViewControllers == nil) {
        _proceedingViewControllers = [[NSMutableArray<UIViewController *> alloc] init];
    }
    
    return _proceedingViewControllers;
}

@end
