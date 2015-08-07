//
//  ATOMHomepageViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHomepageViewController.h"
#import "ATOMHomePageHotTableViewCell.h"
#import "ATOMhomepageAskTableViewCell.h"
#import "ATOMHotDetailViewController.h"
#import "ATOMPageDetailViewController.h"
#import "ATOMUploadWorkViewController.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMProceedingViewController.h"
#import "ATOMAskPageViewModel.h"
#import "ATOMHomepageCustomTitleView.h"
#import "ATOMHomepageScrollView.h"
#import "ATOMShowHomepage.h"
#import "ATOMShareFunctionView.h"
#import "AppDelegate.h"
#import "ATOMBottomCommonButton.h"
#import "ATOMHomeImageDAO.h"
#import "PWPageDetailViewModel.h"
#import "ATOMShareModel.h"
#import "ATOMCollectModel.h"
#import "ATOMInviteViewController.h"
#import "JGActionSheet.h"
#import "ATOMReportModel.h"
#import "ATOMRecordModel.h"
#import "ATOMBaseRequest.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "HMSegmentedControl.h"

@class ATOMHomeImage;

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMHomepageViewController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource,PWRefreshBaseTableViewDelegate,ATOMViewControllerDelegate,ATOMShareFunctionViewDelegate,JGActionSheetDelegate>
@property (nonatomic, strong) ATOMHomepageCustomTitleView *customTitleView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UITapGestureRecognizer *tapHomePageHotGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapHomePageAskGesture;
@property (nonatomic, strong) NSMutableArray *dataSourceOfHotTableView;
@property (nonatomic, strong) NSMutableArray *dataSourceOfRecentTableView;
@property (nonatomic, strong) ATOMHomepageScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentHotPage;
@property (nonatomic, assign) NSInteger currentRecentPage;

@property (nonatomic, assign) BOOL isfirstEnterHomepageRecentView;

@property (nonatomic, assign) BOOL canRefreshHotFooter;
@property (nonatomic, assign) BOOL canRefreshRecentFooter;

@property (nonatomic, strong) ATOMShareFunctionView *shareFunctionView;
@property (nonatomic, strong)  JGActionSheet * cameraActionsheet;
@property (nonatomic, strong)  JGActionSheet * psActionSheet;
@property (nonatomic, strong)  JGActionSheet * reportActionSheet;

@property (nonatomic, strong) UIView *thineNavigationView;

@property (nonatomic, strong) ATOMHomePageHotTableViewCell *selectedHotCell;
@property (nonatomic, strong) ATOMhomepageAskTableViewCell *selectedAskCell;

@property (nonatomic, strong) ATOMAskPageViewModel *selectedAskPageViewModel;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;


@end

@implementation ATOMHomepageViewController

#pragma mark - Lazy Initialize

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [UIImagePickerController new];
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

- (ATOMShareFunctionView *)shareFunctionView {
    if (!_shareFunctionView) {
        _shareFunctionView = [ATOMShareFunctionView new];
        _shareFunctionView.delegate = self;
    }
    return _shareFunctionView;
}

- (JGActionSheet *)psActionSheet {
    WS(ws);
    if (!_psActionSheet) {
        _psActionSheet = [JGActionSheet new];
        JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"下载素材", @"上传作品",@"取消"] buttonStyle:JGActionSheetButtonStyleDefault];
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
                    [ws dealDownloadWork];
                    break;
                case 1:
                    [ws.psActionSheet dismissAnimated:YES];
                    [ws dealUploadWorksWithTag:1];
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

- (JGActionSheet *)cameraActionsheet {
    WS(ws);
    if (!_cameraActionsheet) {
        _cameraActionsheet = [JGActionSheet new];
        JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"求助上传", @"作品上传",@"取消"] buttonStyle:JGActionSheetButtonStyleDefault];
        [section setButtonStyle:JGActionSheetButtonStyleCancel forButtonAtIndex:2];
        NSArray *sections = @[section];
       _cameraActionsheet = [JGActionSheet actionSheetWithSections:sections];
        _cameraActionsheet.delegate = self;
        [_cameraActionsheet setOutsidePressBlock:^(JGActionSheet *sheet) {
            [sheet dismissAnimated:YES];
        }];
        [_cameraActionsheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            switch (indexPath.row) {
                case 0:
                    [ws.cameraActionsheet dismissAnimated:YES];
                    [ws dealSelectingPhotoFromAlbum];
                    break;
                case 1:
                    [ws.cameraActionsheet dismissAnimated:YES];
                    [ws dealUploadWorksWithTag:0];
                    break;
                case 2:
                    [ws.cameraActionsheet dismissAnimated:YES];
                    break;
                default:
                    [ws.cameraActionsheet dismissAnimated:YES];
                    break;
            }
        }];
    }
    return _cameraActionsheet;
}

- (JGActionSheet *)reportActionSheet {
    WS(ws);
    if (!_reportActionSheet) {
        _reportActionSheet = [JGActionSheet new];
        JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"色情、淫秽或低俗内容", @"广告或垃圾信息",@"违反法律法规的内容"] buttonStyle:JGActionSheetButtonStyleDefault];
        NSArray *sections = @[section];
        _reportActionSheet = [JGActionSheet actionSheetWithSections:sections];
        _reportActionSheet.delegate = self;
        [_reportActionSheet setOutsidePressBlock:^(JGActionSheet *sheet) {
            [sheet dismissAnimated:YES];
        }];
        [_reportActionSheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:@(ws.selectedAskPageViewModel.ID) forKey:@"target_id"];
            [param setObject:@(ATOMPageTypeAsk) forKey:@"target_type"];
            UIButton* b = section.buttons[indexPath.row];
            switch (indexPath.row) {
                case 0:
                    [ws.reportActionSheet dismissAnimated:YES];
                    [param setObject:b.titleLabel.text forKey:@"content"];
                    break;
                case 1:
                    [ws.reportActionSheet dismissAnimated:YES];
                    [param setObject:b.titleLabel.text forKey:@"content"];
                    break;
                case 2:
                    [ws.reportActionSheet dismissAnimated:YES];
                    [param setObject:b.titleLabel.text forKey:@"content"];
                    break;
                default:
                    [ws.reportActionSheet dismissAnimated:YES];
                    break;
            }
            [ATOMReportModel report:param withBlock:^(NSError *error) {
                UIView* view;
                if (ws.scrollView.currentHomepageType == ATOMHomepageViewTypeHot) {
                    view = ws.scrollView.homepageHotView;
                } else  if (ws.scrollView.currentHomepageType == ATOMHomepageViewTypeAsk) {
                    view = ws.scrollView.homepageRecentView;
                }
                if(!error) {
                    [Util TextHud:@"已举报" inView:view];
                } 
                
            }];
        }];
    }
    return _reportActionSheet;
}

#pragma mark - ATOMShareFunctionViewDelegate
-(void)tapWechatFriends {
    [self postSocialShare:_selectedAskPageViewModel.ID withSocialShareType:ATOMShareTypeWechatFriends withPageType:ATOMPageTypeAsk];
}
-(void)tapWechatMoment {
    [self postSocialShare:_selectedAskPageViewModel.ID withSocialShareType:ATOMShareTypeWechatMoments withPageType:ATOMPageTypeAsk];
}
-(void)tapSinaWeibo {
    [self postSocialShare:_selectedAskPageViewModel.ID withSocialShareType:ATOMShareTypeSinaWeibo withPageType:ATOMPageTypeAsk];
}
-(void)tapInvite {
    ATOMInviteViewController* ivc = [ATOMInviteViewController new];
    ivc.askPageViewModel = _selectedAskPageViewModel;
    [self pushViewController:ivc animated:YES];
}
-(void)tapCollect {
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (self.shareFunctionView.collectButton.selected) {
        //收藏
        [param setObject:@(1) forKey:@"status"];
    } else {
        //取消收藏
        [param setObject:@(0) forKey:@"status"];
    }
    [ATOMCollectModel toggleCollect:param withPageType:ATOMPageTypeAsk withID:_selectedAskPageViewModel.ID withBlock:^(NSError *error) {
        if (!error) {
            _selectedAskPageViewModel.collected = self.shareFunctionView.collectButton.selected;
        }   else {
            self.shareFunctionView.collectButton.selected = !self.shareFunctionView.collectButton.selected;
        }
    }];
}
-(void)tapReport {
    [self.reportActionSheet showInView:[AppDelegate APP].window animated:YES];
}
#pragma mark - Refresh

- (void)loadNewHotData {
    [self getDataSourceOfTableViewWithHomeType:@"hot"];
}

- (void)loadMoreHotData {
    if (_canRefreshHotFooter) {
        [self getMoreDataSourceOfTableViewWithHomeType:@"hot"];
    } else {
        [_scrollView.homepageHotTableView.footer endRefreshing];
    }
}


- (void)loadNewRecentData {
    [self getDataSourceOfTableViewWithHomeType:@"new"];
}

- (void)loadMoreRecentData {
    if (_canRefreshRecentFooter) {
       [self getMoreDataSourceOfTableViewWithHomeType:@"new"];
    } else {
        [_scrollView.homepageAskTableView.footer endRefreshing];
    }
}

#pragma mark - PWRefreshBaseTableViewDelegate

-(void)didPullRefreshDown:(UITableView *)tableView{
    if (tableView == _scrollView.homepageHotTableView) {
        [self loadNewHotData];
    } else if(tableView == _scrollView.homepageAskTableView) {
        [self loadNewRecentData];
    }
}

-(void)didPullRefreshUp:(UITableView *)tableView {
    if (tableView == _scrollView.homepageHotTableView) {
        [self loadMoreHotData];
    } else if(tableView == _scrollView.homepageAskTableView) {
        [self loadMoreRecentData];
    }
}




#pragma mark - GetDataSource from DB
- (void)firstGetDataSourceFromDataBase {
    _dataSourceOfHotTableView = [self fetchDBDataSourceWithHomeType:ATOMHomepageViewTypeHot];
    [self.scrollView.homepageHotTableView reloadData];

    _dataSourceOfRecentTableView = [self fetchDBDataSourceWithHomeType:ATOMHomepageViewTypeAsk];
    [self.scrollView.homepageAskTableView reloadData];
}
#pragma mark - GetDataSource from Server

//初始数据
- (void)firstGetDataSourceOfTableViewWithHomeType:(ATOMHomepageViewType)homeType {
    if (homeType == ATOMHomepageViewTypeHot) {
        [_scrollView.homepageHotTableView.header beginRefreshing];
//        [self loadNewHotData];
    } else if (homeType == ATOMHomepageViewTypeAsk) {
        [_scrollView.homepageAskTableView.header beginRefreshing];
//            [self loadNewRecentData];
    }
}

-(NSMutableArray*)fetchDBDataSourceWithHomeType:(ATOMHomepageViewType) homeType {
    ATOMShowHomepage *showHomepage = [ATOMShowHomepage new];
    NSArray * homepageArray = [[showHomepage getHomeImagesWithHomeType:homeType] mutableCopy];
   NSMutableArray* tableViewDataSource = [NSMutableArray array];
    for (ATOMHomeImage *homeImage in homepageArray) {
        ATOMAskPageViewModel *model = [ATOMAskPageViewModel new];
        [model setViewModelData:homeImage];
        [tableViewDataSource addObject:model];
    }
    return tableViewDataSource;
}

//获取服务器的最新数据
- (void)getDataSourceOfTableViewWithHomeType:(NSString *)homeType {
    WS(ws);
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    double timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(SCREEN_WIDTH - 2 * kPadding15) forKey:@"width"];
    [param setObject:homeType forKey:@"type"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(8) forKey:@"size"];
    ATOMShowHomepage *showHomepage = [ATOMShowHomepage new];
    [showHomepage ShowHomepage:param withBlock:^(NSMutableArray *homepageArray, NSError *error) {
        if (homepageArray.count != 0 && error == nil) {
//            [showHomepage clearHomePagesWithHomeType:homeType];
            if ([homeType isEqualToString:@"new"]) {
                _dataSourceOfRecentTableView = nil;
                _dataSourceOfRecentTableView = [NSMutableArray array];
                _currentRecentPage = 1;
                [param setObject:@(_currentRecentPage) forKey:@"page"];
            } else if ([homeType isEqualToString:@"hot"]) {
                _dataSourceOfHotTableView = nil;
                _dataSourceOfHotTableView = [NSMutableArray array];
                _currentHotPage = 1;
                [param setObject:@(_currentHotPage) forKey:@"page"];
            }
            
            for (ATOMHomeImage *homeImage in homepageArray) {
                ATOMAskPageViewModel *model = [ATOMAskPageViewModel new];
                [model setViewModelData:homeImage];
                if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageViewTypeHot) {
                    [ws.dataSourceOfHotTableView addObject:model];
                } else if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageViewTypeAsk) {
                    [ws.dataSourceOfRecentTableView addObject:model];
                }
            }
            if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageViewTypeHot) {
                [ws.scrollView.homepageHotTableView reloadData];
                [ws.scrollView.homepageHotTableView.header endRefreshing];
            } else if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageViewTypeAsk) {
                [ws.scrollView.homepageAskTableView reloadData];
                [ws.scrollView.homepageAskTableView.header endRefreshing];
            }
            [showHomepage saveHomeImagesInDB:homepageArray];
        } else {
            [ws.scrollView.homepageHotTableView.header endRefreshing];
            [ws.scrollView.homepageAskTableView.header endRefreshing];
        }
    }];

}

//拉至底层刷新
- (void)getMoreDataSourceOfTableViewWithHomeType:(NSString *)homeType {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary new];
    double timeStamp = [[NSDate date] timeIntervalSince1970];
    if ([homeType isEqualToString:@"new"]) {
        ws.currentRecentPage++;
        [param setObject:@(ws.currentRecentPage) forKey:@"page"];
    } else if ([homeType isEqualToString:@"hot"]) {
        ws.currentHotPage++;
        [param setObject:@(ws.currentHotPage) forKey:@"page"];
    }
    [param setObject:@(SCREEN_WIDTH - kPadding15 * 2) forKey:@"width"];
    [param setObject:homeType forKey:@"type"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(10) forKey:@"size"];
    ATOMShowHomepage *showHomepage = [ATOMShowHomepage new];
    [showHomepage ShowHomepage:param withBlock:^(NSMutableArray *homepageArray,     NSError *error) {
        if (homepageArray && error == nil) {

            for (ATOMHomeImage *homeImage in homepageArray) {
                ATOMAskPageViewModel *model = [ATOMAskPageViewModel new];
                [model setViewModelData:homeImage];
                if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageViewTypeHot) {
                    [ws.dataSourceOfHotTableView addObject:model];
                } else if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageViewTypeAsk) {
                    [ws.dataSourceOfRecentTableView addObject:model];
                }
            }
            if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageViewTypeHot) {
                [ws.scrollView.homepageHotTableView reloadData];
                [ws.scrollView.homepageHotTableView.footer endRefreshing];
                if (homepageArray.count == 0) {
                    ws.canRefreshHotFooter = NO;
                } else {
                    ws.canRefreshHotFooter = YES;
                }
            } else if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageViewTypeAsk) {
                [ws.scrollView.homepageAskTableView reloadData];
                [ws.scrollView.homepageAskTableView.footer endRefreshing];
                if (homepageArray.count == 0) {
                    ws.canRefreshRecentFooter = NO;
                } else {
                    ws.canRefreshRecentFooter = YES;
                }
            }
        } else {
        }
    }];
}

#pragma mark - UI

- (void)viewDidLoad {

    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
-(void)viewDidAppear:(BOOL)animated {
//    NSLog(@"viewDidAppear");
//    if ([_scrollView typeOfCurrentHomepageView] == ATOMHomepageViewTypeHot && !_isfirstEnterHomepage) {
//        [_scrollView.homepageHotTableView.header beginRefreshing];
//        NSLog(@"viewDidAppear beginRefreshing1");
//    } else if ([_scrollView typeOfCurrentHomepageView] == ATOMHomepageViewTypeAsk && !_isfirstEnterHomepageRecentView) {
//        [_scrollView.homepageAskTableView.header beginRefreshing];
//        NSLog(@"viewDidAppear beginRefreshing2");
//    }
//    _isfirstEnterHomepage = NO;
}
- (void)createUI {
    [self createCustomNavigationBar];
    _scrollView = [ATOMHomepageScrollView new];
    _scrollView.delegate =self;
    self.view = _scrollView;
    [self configHomepageHotTableView];
    [self confighomepageAskTableView];
    _isfirstEnterHomepageRecentView = YES;
    _canRefreshHotFooter = YES;
    _canRefreshRecentFooter = YES;
    [self firstGetDataSourceFromDataBase];
    [self firstGetDataSourceOfTableViewWithHomeType:ATOMHomepageViewTypeHot];
}

- (void)configHomepageHotTableView {
    _scrollView.homepageHotTableView.delegate = self;
    _scrollView.homepageHotTableView.dataSource = self;
    _scrollView.homepageHotTableView.psDelegate = self;
    _scrollView.homepageHotTableView.estimatedRowHeight = 340;
    _tapHomePageHotGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHomePageHotGesture:)];
    [_scrollView.homepageHotTableView addGestureRecognizer:_tapHomePageHotGesture];
}
- (void)confighomepageAskTableView {
    _scrollView.homepageAskTableView.delegate = self;
    _scrollView.homepageAskTableView.dataSource = self;
    _scrollView.homepageAskTableView.psDelegate = self;
    _scrollView.homepageAskTableView.estimatedRowHeight = 340;
    _tapHomePageAskGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHomePageAskGesture:)];
    [_scrollView.homepageAskTableView addGestureRecognizer:_tapHomePageAskGesture];
}

- (void)createCustomNavigationBar {
    WS(ws);
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 0;
    UIView *cameraView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
    UIButton *cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
    [cameraButton setImage:[UIImage imageNamed:@"btn_psask_normal"] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"btn_psask_pressed"] forState:UIControlStateHighlighted];
    [cameraButton setImageEdgeInsets:UIEdgeInsetsMake(5.5, 5, 5.5, 0)];
    [cameraButton addTarget:self action:@selector(clickCameraButton:) forControlEvents:UIControlEventTouchUpInside];
    [cameraView addSubview:cameraButton];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cameraView];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightButtonItem];


    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionImages:@[[UIImage imageNamed:@"btn_home_hot"], [UIImage imageNamed:@"btn_home_ask"]] sectionSelectedImages:nil];
    _segmentedControl.frame = CGRectMake(0, 120, 200, 45);
    _segmentedControl.selectionIndicatorHeight = 4.0f;
    _segmentedControl.selectionIndicatorColor = [UIColor colorWithHex:0x000000 andAlpha:0.2];
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        if (index == 0) {
            [ws clickHotTitleButton];
        } else if (index == 1) {
            [ws clickRecentTitleButton];
        }
    }];

    _segmentedControl.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = _segmentedControl;

}

#pragma mark - Click Event

- (void)clickHotTitleButton {
    [_scrollView changeUIAccording:@"热门"];
}

- (void)clickRecentTitleButton {
    [_scrollView changeUIAccording:@"最新"];
    if (_isfirstEnterHomepageRecentView) {
        _isfirstEnterHomepageRecentView = NO;
        [self firstGetDataSourceOfTableViewWithHomeType:ATOMHomepageViewTypeAsk];
    }
}

- (void)clickCameraButton:(UIBarButtonItem *)sender {
    [self.cameraActionsheet showInView:[AppDelegate APP].window animated:YES];
}

- (void)dealSelectingPhotoFromAlbum {
    [[NSUserDefaults standardUserDefaults] setObject:@"Ask" forKey:@"AskOrReply"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePickerController animated:YES completion:NULL];
    }
    else
    {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"😭" andMessage:@"找不到你的相册在哪"];
        [alertView addButtonWithTitle:@"我知道了"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                              }];
        alertView.transitionStyle = SIAlertViewTransitionStyleFade;
        [alertView show];
    }
}
- (void)tapOnImageView:(UIImage*)image withURL:(NSString*)url{
    
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    if (image != nil) {
        imageInfo.image = image;
    } else {
        imageInfo.imageURL = [NSURL URLWithString:url];
    }
    imageInfo.referenceRect = _selectedAskCell.userHeaderButton.frame;
    imageInfo.referenceView = _selectedAskCell.userHeaderButton;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
//    imageViewer.interactionsDelegate = self;
}
/**
 *  上传作品
 *
 *  @param tag 0:->进行中  1:->选择相册图片
 */
- (void)dealUploadWorksWithTag:(NSInteger)tag {
    [[NSUserDefaults standardUserDefaults] setObject:@"Reply" forKey:@"AskOrReply"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (tag == 0) {
        ATOMProceedingViewController *pvc = [ATOMProceedingViewController new];
        [self pushViewController:pvc animated:YES];
    } else {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_imagePickerController animated:YES completion:NULL];
        }
        else
        {
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"😭" andMessage:@"找不到你的相册在哪"];
            [alertView addButtonWithTitle:@"我知道了"
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alert) {
                                  }];
            alertView.transitionStyle = SIAlertViewTransitionStyleFade;
            [alertView show];
        }
    }
}

- (void)dealDownloadWork {
    NSMutableDictionary* param = [NSMutableDictionary new];
    [param setObject:@"ask" forKey:@"type"];
    [param setObject:@(_selectedAskCell.viewModel.ID) forKey:@"target"];
    [ATOMRecordModel record:param withBlock:^(NSError *error, NSString *url) {
        if (!error) {
            [ATOMBaseRequest downloadImage:url withBlock:^(UIImage *image) {
                UIImageWriteToSavedPhotosAlbum(image,self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            }];
        }
    }];
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
  contextInfo: (void *) contextInfo {
    if(error != NULL){
        [Util TextHud:@"保存失败"];
    }else{
        [Util TextHud:@"保存成功"];
    }
}

#pragma mark - Gesture Event

- (void)tapHomePageHotGesture:(UITapGestureRecognizer *)gesture {
    if ([_scrollView typeOfCurrentHomepageView] == ATOMHomepageViewTypeHot) {
        CGPoint location = [gesture locationInView:_scrollView.homepageHotTableView];
        NSIndexPath *indexPath = [_scrollView.homepageHotTableView indexPathForRowAtPoint:location];
        if (indexPath) {
            _selectedHotCell = (ATOMHomePageHotTableViewCell *)[_scrollView.homepageHotTableView cellForRowAtIndexPath:indexPath];
            CGPoint p = [gesture locationInView:_selectedHotCell];
            _selectedAskPageViewModel = _dataSourceOfHotTableView[indexPath.row];
            
            if (CGRectContainsPoint(_selectedHotCell.userWorkImageView.frame, p)) {
                //进入热门详情
                ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
                hdvc.delegate = self;
                hdvc.fold = 0;
                hdvc.askPageViewModel = _dataSourceOfHotTableView[indexPath.row];
                [self pushViewController:hdvc animated:YES];
            } else if (CGRectContainsPoint(_selectedHotCell.topView.frame, p)) {
                p = [gesture locationInView:_selectedHotCell.topView];
                if (CGRectContainsPoint(_selectedHotCell.userHeaderButton.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    opvc.userID = _selectedAskPageViewModel.userID;
                    opvc.userName = _selectedAskPageViewModel.userName;
                    [self pushViewController:opvc animated:YES];
                } else if (CGRectContainsPoint(_selectedHotCell.userNameLabel.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    opvc.userID = _selectedAskPageViewModel.userID;
                    opvc.userName = _selectedAskPageViewModel.userName;
                    [self pushViewController:opvc animated:YES];
                }
            } else if (CGRectContainsPoint(_selectedHotCell.thinCenterView.frame, p)){
                p = [gesture locationInView:_selectedHotCell.thinCenterView];
                if (CGRectContainsPoint(_selectedHotCell.praiseButton.frame, p)) {
                    [_selectedHotCell.praiseButton toggleLike];
                    [_selectedAskPageViewModel toggleLike];
                } else if (CGRectContainsPoint(_selectedHotCell.shareButton.frame, p)) {
                    [self postSocialShare:_selectedAskPageViewModel.ID withSocialShareType:ATOMShareTypeWechatMoments withPageType:ATOMPageTypeAsk];
                } else if (CGRectContainsPoint(_selectedHotCell.commentButton.frame, p)) {
                    ATOMPageDetailViewController *rdvc = [ATOMPageDetailViewController new];
                    rdvc.delegate = self;
                    PWPageDetailViewModel* pageDetailViewModel = [PWPageDetailViewModel new];
                    [pageDetailViewModel setCommonViewModelWithAsk:_selectedAskPageViewModel];
                    rdvc.pageDetailViewModel = pageDetailViewModel;
                    [self pushViewController:rdvc animated:YES];
                } else if (CGRectContainsPoint(_selectedHotCell.moreShareButton.frame, p)) {
                    self.shareFunctionView.collectButton.selected = _selectedAskPageViewModel.collected;
                    [self.shareFunctionView showInView:[AppDelegate APP].window animated:YES];
                }
            }
        }
    }
}

- (void)tapHomePageAskGesture:(UITapGestureRecognizer *)gesture {
    if ([_scrollView typeOfCurrentHomepageView] == ATOMHomepageViewTypeAsk) {
        CGPoint location = [gesture locationInView:_scrollView.homepageAskTableView];
        NSIndexPath *indexPath = [_scrollView.homepageAskTableView indexPathForRowAtPoint:location];
        if (indexPath) {
            _selectedAskCell = (ATOMhomepageAskTableViewCell *)[_scrollView.homepageAskTableView cellForRowAtIndexPath:indexPath];
            CGPoint p = [gesture locationInView:_selectedAskCell];
            _selectedAskPageViewModel = _dataSourceOfRecentTableView[indexPath.row];
            if (CGRectContainsPoint(_selectedAskCell.userWorkImageView.frame, p)) {
                [self tapOnImageView:_selectedAskCell.userWorkImageView.image withURL:_selectedAskCell.viewModel.userImageURL];
            } else if (CGRectContainsPoint(_selectedAskCell.topView.frame, p)) {
                p = [gesture locationInView:_selectedAskCell.topView];
                if (CGRectContainsPoint(_selectedAskCell.userHeaderButton.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    opvc.userID = _selectedAskPageViewModel.userID;
                    opvc.userName = _selectedAskPageViewModel.userName;
                    [self pushViewController:opvc animated:YES];
                } else if (CGRectContainsPoint(_selectedAskCell.psButton.frame, p)) {
                    [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
                } else if (CGRectContainsPoint(_selectedAskCell.userNameLabel.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    opvc.userID = _selectedAskPageViewModel.userID;
                    opvc.userName = _selectedAskPageViewModel.userName;
                    [self pushViewController:opvc animated:YES];
                }
            } else if (CGRectContainsPoint(_selectedAskCell.thinCenterView.frame, p)){
                p = [gesture locationInView:_selectedAskCell.thinCenterView];
                if (CGRectContainsPoint(_selectedAskCell.praiseButton.frame, p)) {
                    [_selectedAskCell.praiseButton toggleLike];
                    [_selectedAskPageViewModel toggleLike];
                } else if (CGRectContainsPoint(_selectedAskCell.shareButton.frame, p)) {
                    [self postSocialShare:_selectedAskPageViewModel.ID withSocialShareType:ATOMShareTypeWechatMoments withPageType:ATOMPageTypeAsk];
                } else if (CGRectContainsPoint(_selectedAskCell.commentButton.frame, p)) {
                    ATOMPageDetailViewController *rdvc = [ATOMPageDetailViewController new];
                    rdvc.delegate = self;
                    PWPageDetailViewModel* pageDetailViewModel = [PWPageDetailViewModel new];
                    [pageDetailViewModel setCommonViewModelWithAsk:_selectedAskPageViewModel];
                    rdvc.pageDetailViewModel = pageDetailViewModel;
                    [self pushViewController:rdvc animated:YES];
                } else if (CGRectContainsPoint(_selectedAskCell.moreShareButton.frame, p)) {
                    self.shareFunctionView.collectButton.selected = _selectedAskPageViewModel.collected;
                    [self.shareFunctionView show];
                }
            }
            
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    WS(ws);
    [self dismissViewControllerAnimated:YES completion:^{
        ATOMUploadWorkViewController *uwvc = [ATOMUploadWorkViewController new];
        uwvc.originImage = info[UIImagePickerControllerOriginalImage];
        uwvc.askPageViewModel = ws.selectedAskPageViewModel;
        [ws pushViewController:uwvc animated:YES];
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        int currentPage = (_scrollView.contentOffset.x + CGWidth(_scrollView.frame) * 0.1) / CGWidth(_scrollView.frame);
        if (currentPage == 0) {
            [_scrollView changeUIAccording:@"热门"];
            [_segmentedControl setSelectedSegmentIndex:0 animated:YES];
        } else if (currentPage == 1) {
            [_segmentedControl setSelectedSegmentIndex:1 animated:YES];
            [_scrollView changeUIAccording:@"最新"];
            if (_isfirstEnterHomepageRecentView) {
                _isfirstEnterHomepageRecentView = NO;
                [self firstGetDataSourceOfTableViewWithHomeType:ATOMHomepageViewTypeAsk];
            }
        }
    }
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_scrollView.homepageHotTableView == tableView) {
        return _dataSourceOfHotTableView.count;
    } else if (_scrollView.homepageAskTableView == tableView) {
        return _dataSourceOfRecentTableView.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_scrollView.homepageHotTableView == tableView) {
        static NSString *CellIdentifier1 = @"HomePageHotCell";
        ATOMHomePageHotTableViewCell *cell = [_scrollView.homepageHotTableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (!cell) {
            cell = [[ATOMHomePageHotTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        }
        cell.viewModel = _dataSourceOfHotTableView[indexPath.row];
        return cell;
    } else if (_scrollView.homepageAskTableView == tableView) {
        static NSString *CellIdentifier2 = @"HomePageRecentCell";
        ATOMhomepageAskTableViewCell *cell = [_scrollView.homepageAskTableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (!cell) {
            cell = [[ATOMhomepageAskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        cell.viewModel = _dataSourceOfRecentTableView[indexPath.row];
        return cell;
    } else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_scrollView.homepageHotTableView == tableView) {
        return [ATOMHomePageHotTableViewCell calculateCellHeightWith:_dataSourceOfHotTableView[indexPath.row]];
    } else if (_scrollView.homepageAskTableView == tableView) {
        return [ATOMhomepageAskTableViewCell calculateCellHeightWith:_dataSourceOfRecentTableView[indexPath.row]];
    } else {
        return 0;
    }
}

#pragma mark - ATOMViewControllerDelegate


-(void)ATOMViewControllerDismissWithInfo:(NSDictionary *)info {
    bool liked = [info[@"liked"] boolValue];
    bool collected = [info[@"collected"]boolValue];
    if (_scrollView.typeOfCurrentHomepageView == ATOMHomepageViewTypeHot) {
        //当从child viewcontroller 传来的liked变化的时候，toggle like.
        //to do:其实应该改变datasource的liked ,tableView reload的时候才能保持。
        [_selectedHotCell.praiseButton toggleLikeWhenSelectedChanged:liked];
        _selectedAskPageViewModel.collected = collected;
        NSLog(@"_selectedAskPageViewModel.collected %d",collected);

    } else if (_scrollView.typeOfCurrentHomepageView == ATOMHomepageViewTypeAsk) {
        [_selectedAskCell.praiseButton toggleLikeWhenSelectedChanged:liked];
        _selectedAskPageViewModel.collected = collected;
    }
}





@end
