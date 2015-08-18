//
//  ATOMProceedingViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMProceedingViewController.h"
#import "ATOMProceedingTableViewCell.h"
#import "ATOMCropImageController.h"
#import "HotDetailViewController.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMHomeImage.h"
#import "ATOMAskPageViewModel.h"
#import "ATOMProceedingViewModel.h"
#import "ATOMShowProceeding.h"
#import "RefreshFooterTableView.h"
#import "ATOMCommonModel.h"
#import "MessageViewController.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMProceedingViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,PWRefreshBaseTableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) UIView *proceedingView;
@property (nonatomic, strong) RefreshFooterTableView *tableView;
@property (nonatomic, strong) UITapGestureRecognizer *tapProceedingGesture;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *homeImageDataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSIndexPath* selectedIndexPath;

@property (nonatomic, assign) BOOL canRefreshFooter;

@end

@implementation ATOMProceedingViewController

#pragma mark - Lazy Initialize

- (UITapGestureRecognizer *)tapProceedingGesture {
    if (!_tapProceedingGesture) {
        _tapProceedingGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProceedingGesture:)];
    }
    return _tapProceedingGesture;
}

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [UIImagePickerController new];
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

#pragma mark - Refresh
-(void)didPullRefreshUp:(UITableView *)tableView{
    [self loadMoreData];
}

- (void)loadData {
    [self getDataSource];
}

- (void)loadMoreData {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [_tableView.footer endRefreshing];
    }
    
}

#pragma mark - GetDataSource

- (void)getDataSource {
    WS(ws);
    [[KShareManager mascotAnimator]show];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    _currentPage = 1;
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH - 2 * kPadding15) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(10) forKey:@"size"];
    ATOMShowProceeding *showProceeding = [ATOMShowProceeding new];
    [showProceeding ShowProceeding:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        if (resultArray.count) {
            [_dataSource removeAllObjects];
            [_homeImageDataSource removeAllObjects];
        }
        for (ATOMHomeImage *homeImage in resultArray) {
            ATOMAskPageViewModel *homepageViewModel = [ATOMAskPageViewModel new];
            [homepageViewModel setViewModelData:homeImage];
            [ws.homeImageDataSource addObject:homepageViewModel];
            ATOMProceedingViewModel *proceedingViewModel = [ATOMProceedingViewModel new];
            [proceedingViewModel setViewModelData:homeImage];
            [ws.dataSource addObject:proceedingViewModel];
        }
        [[KShareManager mascotAnimator]dismiss];
        _tableView.dataSource = self;
        [ws.tableView reloadData];
    }];
}

- (void)getMoreDataSource {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timestamp = [[NSDate date] timeIntervalSince1970];
    ws.currentPage++;
    [param setObject:@(ws.currentPage) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH - 2 * kPadding15) forKey:@"width"];
    [param setObject:@(timestamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    ATOMShowProceeding *showProceeding = [ATOMShowProceeding new];
    ////[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [showProceeding ShowProceeding:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        ////[SVProgressHUD dismiss];
        for (ATOMHomeImage *homeImage in resultArray) {
            ATOMAskPageViewModel *homepageViewModel = [ATOMAskPageViewModel new];
            [homepageViewModel setViewModelData:homeImage];
            [ws.homeImageDataSource addObject:homepageViewModel];
            ATOMProceedingViewModel *proceedingViewModel = [ATOMProceedingViewModel new];
            [proceedingViewModel setViewModelData:homeImage];
            [ws.dataSource addObject:proceedingViewModel];
        }
        if (resultArray.count == 0) {
            ws.canRefreshFooter = NO;
        } else {
            ws.canRefreshFooter = YES;
        }
        [ws.tableView.footer endRefreshing];
        [ws.tableView reloadData];
    }];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"进行中";
    _proceedingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _proceedingView;
    _tableView = [[RefreshFooterTableView alloc] initWithFrame:_proceedingView.bounds];
    [_proceedingView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = nil;
    _tableView.psDelegate = self;
    _tableView.emptyDataSetSource = self;
    [_tableView addGestureRecognizer:self.tapProceedingGesture];
    _canRefreshFooter = YES;
    _dataSource = nil;
    _dataSource = [NSMutableArray array];
    _homeImageDataSource = nil;
    _homeImageDataSource = [NSMutableArray array];
    [self getDataSource];
}

#pragma mark - Gesture Event

- (void)tapProceedingGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    _selectedIndexPath = indexPath;
    if (indexPath) {
        ATOMProceedingTableViewCell *cell = (ATOMProceedingTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        //点击图片
        if (CGRectContainsPoint(cell.uploadButton.frame, p)) {
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"上传作品" andMessage:@"确定要上传你的作品到这个求P中吗？"];
            [alertView addButtonWithTitle:@"取消"
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alert) {
                                  }];
            [alertView addButtonWithTitle:@"确定"
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alert) {
                                      [self dealUploadWork];
                                  }];

            alertView.transitionStyle = SIAlertViewTransitionStyleFade;
            [alertView show];
        } else if (CGRectContainsPoint(cell.userUploadImageView.frame, p)) {

            ATOMAskPageViewModel* askPVM = _homeImageDataSource[indexPath.row];

            if ([askPVM.totalPSNumber integerValue] == 0) {
                MessageViewController* mvc = [MessageViewController new];
                mvc.vm = [askPVM generatepageDetailViewModel];
//                mvc.delegate = self;
                [self pushViewController:mvc animated:YES];

            } else {
                HotDetailViewController *hdvc = [HotDetailViewController new];
                hdvc.askPageViewModel = askPVM;
                hdvc.fold = 0;
                [self pushViewController:hdvc animated:YES];
            }
            
        } else if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            opvc.userID = cell.viewModel.userID;
            opvc.userName = cell.viewModel.userName;
            [self pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.userNameLabel.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            opvc.userID = cell.viewModel.userID;
            opvc.userName = cell.viewModel.userName;
            [self pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.deleteButton.frame, p)) {
            NSDictionary* param = [[NSDictionary alloc]initWithObjectsAndKeys:@(cell.viewModel.ID),@"id", nil];
            [ATOMCommonModel post:param withUrl:@"user/delete_progress" withBlock:^(NSError *error,int ret) {
                if (!error) {
                    [Util successHud:@"已删除" inView:self.view];
                }
                [_dataSource removeObjectAtIndex:indexPath.row];
                [_tableView reloadData];
            }];
        }
    }
}

#pragma mark - Click Event

- (void)dealUploadWork {
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

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    WS(ws);
    [self dismissViewControllerAnimated:YES completion:^{
        ATOMCropImageController *uwvc = [ATOMCropImageController new];
        uwvc.originImage = info[UIImagePickerControllerOriginalImage];
        uwvc.askPageViewModel = [_homeImageDataSource objectAtIndex:_selectedIndexPath.row];
        [ws pushViewController:uwvc animated:YES];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ProceedingCell";
    ATOMProceedingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMProceedingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.viewModel = _dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ATOMProceedingTableViewCell calculateCellHeight:_dataSource[indexPath.row]];
}

#pragma mark - DZNEmptyDataSetSource & delegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"ic_cry"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"你没有下载任何素材，去首页看看吧";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


@end
