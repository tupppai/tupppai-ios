//
//  PIEChannelTutorialContainerViewController.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/28/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialContainerViewController.h"
#import "PIEChannelTutorialDetailViewController.h"
#import "PIEChannelTutorialHomeworkViewController.h"
#import "HMSegmentedControl.h"
#import "PIEChannelTutorialModel.h"

@interface PIEChannelTutorialContainerViewController ()
<
    UIScrollViewDelegate
>

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray <UIViewController *> *tutorialViewControllers;

@end

typedef NS_ENUM(NSUInteger, PIEChannelTutorialControllerType) {
    PIEChannelTutorialControllerTypeDetails,
    PIEChannelTutorialControllerTypeHomework
};

@implementation PIEChannelTutorialContainerViewController

- (void)loadView
{
    [super loadView];
    
    self.view = self.scrollView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupNavigationItem];
    
    [self setupViewControllers];
    
    self.scrollView.contentSize =
    CGSizeMake(self.tutorialViewControllers.count * SCREEN_WIDTH, 0);
    
    [self addSubViewControllers];
    
    [self setupRAC];
    
    // call the first view controller to start refreshing & fetch data
    // ...
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    // remove child view controllers
    for (UIViewController *vc in self.tutorialViewControllers) {
        [vc willMoveToParentViewController:nil];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
}

#pragma mark - UI components setup
- (void)setupViewControllers
{
    // create view controllers and add them to array
    
    PIEChannelTutorialDetailViewController *tutorialDetailViewController     = [PIEChannelTutorialDetailViewController new];
    PIEChannelTutorialHomeworkViewController *tutorialHomeworkViewController = [PIEChannelTutorialHomeworkViewController new];
    
    tutorialDetailViewController.currentTutorialModel = self.currentTutorialModel;
    
    [self.tutorialViewControllers addObject:tutorialDetailViewController];
    [self.tutorialViewControllers addObject:tutorialHomeworkViewController];
}
- (void)addSubViewControllers
{
    // add view controllers as child view controllers
    for (int i = 0; i < self.tutorialViewControllers.count; i++) {
        UIViewController *vc = self.tutorialViewControllers[i];
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
    self.navigationItem.titleView = self.segmentedControl;
}

- (void)setupRAC
{
    
}

#pragma mark - Toggle view controllers
- (void)toggleViewController:(PIEChannelTutorialControllerType)controllerType
{
    if (controllerType == PIEChannelTutorialControllerTypeDetails) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.scrollView.contentOffset = CGPointMake(0, 0);
                         }];
    }else if (controllerType == PIEChannelTutorialControllerTypeHomework)
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
                         }];
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentPage = (scrollView.contentOffset.x + CGWidth(scrollView.frame) * 0.1) / CGWidth(scrollView.frame);
    
    if (currentPage == 0) {
        [self.segmentedControl setSelectedSegmentIndex:0 animated:YES];
        
        // refresh if is first loaded
    }
    else if (currentPage == 1){
        [self.segmentedControl setSelectedSegmentIndex:1 animated:YES];
        
        // refresh if is first loaded
        
    }
}

#pragma mark - lazy loadings
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView                                = [[UIScrollView alloc] init];
        _scrollView.frame                          = [UIScreen mainScreen].bounds;
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled                  = YES;
        _scrollView.scrollsToTop                   = NO;
        _scrollView.delegate                       = self;
    }
    
    return _scrollView;
}



- (NSMutableArray<UIViewController *> *)tutorialViewControllers
{
    if (_tutorialViewControllers == nil) {
        _tutorialViewControllers = [[NSMutableArray<UIViewController *> alloc] init];
    }
    
    return _tutorialViewControllers;
}

- (HMSegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil) {
        @weakify(self);
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"详情",@"作业"]];
        _segmentedControl.frame = CGRectMake(0, 120, SCREEN_WIDTH - 40, 45);
        _segmentedControl.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor colorWithHex:0x000000 andAlpha:0.6], NSForegroundColorAttributeName, nil];
        _segmentedControl.selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
        _segmentedControl.selectionIndicatorHeight = 4.0f;
        _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -1, 0);
        _segmentedControl.selectionIndicatorColor = [UIColor yellowColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmentedControl.backgroundColor = [UIColor clearColor];
        
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            @strongify(self);
            if (index == 0) {
                [self toggleViewController:PIEChannelTutorialControllerTypeDetails];
                
                // fetch & reload data if is first loaded
            }else if (index == 1)
            {
                [self toggleViewController:PIEChannelTutorialControllerTypeHomework];
            }
        }];
    }
    return _segmentedControl;
}

@end
