//
//  PIESearchUserViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 12/18/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIESearchUserViewController.h"

//#import "PIERefreshCollectionView.h"
//#import "PIESearchUserSimpleCollectionCell.h"
//#import "PIESearchUserCollectionViewCell.h"
#import "PIERefreshTableView.h"
#import "PIESearchUserSimpleTableViewCell.h"
#import "PIESearchUserTableViewCell.h"

#import "PIESearchManager.h"
#import "PIEFriendViewController.h"

@interface PIESearchUserViewController ()
<

//    UICollectionViewDataSource,UICollectionViewDelegate,
//    CHTCollectionViewDelegateWaterfallLayout,
//    PWRefreshBaseCollectionViewDelegate

    UITableViewDataSource, UITableViewDelegate,
    PWRefreshBaseTableViewDelegate,
    DZNEmptyDataSetDelegate,DZNEmptyDataSetSource

>

//@property (nonatomic, strong) PIERefreshCollectionView *collectionView;
@property (nonatomic, strong) PIERefreshTableView *tableView;

@property (nonatomic, strong) NSMutableArray<PIEUserViewModel *> *source;

//@property (nonatomic, strong) CHTCollectionViewWaterfallLayout   *layout;

@property (nonatomic, assign) BOOL notFirstLoading;
@property (nonatomic, assign) long long timeStamp;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation PIESearchUserViewController

static NSString *PIESearchUserSimpleTableViewCellIdentifier =
@"PIESearchUserSimpleTableViewCell";

static NSString *PIESearchUserTableViewCellIdentifier =
@"PIESearchUserTableViewCell";

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view addSubview:self.collectionView];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view);
//        make.bottom.equalTo(self.view);
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gesture methods
- (void)tapOnTableView:(UITapGestureRecognizer *)gesture{
    
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *selectedIndexPath =
    [self.tableView indexPathForRowAtPoint:location];
    
    if (selectedIndexPath != nil) {
        PIEUserViewModel* vm = [_source objectAtIndex:selectedIndexPath.row];
        
        /*
            Question: 就算PIESearchUserTableViewCell &
                         PIESearchUserSimpleTableViewCell 类似，但是这里真的不用做一步判断
                      然后再分别处理吗？
         */
//        PIESearchUserCollectionViewCell* cell = (PIESearchUserCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:selectedIndexPath];
        
        PIESearchUserTableViewCell *cell =
        (PIESearchUserTableViewCell *)
        [self.tableView cellForRowAtIndexPath:selectedIndexPath];
        
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.avatarButton.frame, p) ||
            CGRectContainsPoint(cell.nameButton.frame, p)) {
            PIEFriendViewController* vc = [PIEFriendViewController new];
            vc.uid = vm.model.uid;
            vc.name = vm.username;
            [self.parentViewController.view.superview.viewController.navigationController  pushViewController:vc animated:YES];
        } else if (CGRectContainsPoint(cell.followButton.frame, p)) {
            /* 点击了关注按钮 */
            cell.followButton.selected = !cell.followButton.selected;
            NSMutableDictionary *param = [NSMutableDictionary new];
            [param setObject:@(vm.model.uid) forKey:@"uid"];
            [DDService follow:param withBlock:^(BOOL success) {
                if (!success) {
                    cell.followButton.selected = !cell.followButton.selected;
                } else {
                }
            }];
            
        }
    }
}

//- (void)tapOnCollectionView:(UITapGestureRecognizer*)gesture {
//    
//    CGPoint location = [gesture locationInView:self.collectionView];
//    NSIndexPath* selectedIndexPath = [self.collectionView indexPathForItemAtPoint:location];
//    if (selectedIndexPath) {
//        PIEUserViewModel* vm = [_source objectAtIndex:selectedIndexPath.row];
//        PIESearchUserCollectionViewCell* cell = (PIESearchUserCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:selectedIndexPath];
//        CGPoint p = [gesture locationInView:cell];
//        if (CGRectContainsPoint(cell.avatarButton.frame, p) || CGRectContainsPoint(cell.nameButton.frame, p)) {
//            PIEFriendViewController* vc = [PIEFriendViewController new];
//            vc.uid = vm.model.uid;
//            vc.name = vm.username;
//            [self.parentViewController.view.superview.viewController.navigationController  pushViewController:vc animated:YES];
//        } else if (CGRectContainsPoint(cell.followButton.frame, p)) {
//            cell.followButton.selected = !cell.followButton.selected;
//            NSMutableDictionary *param = [NSMutableDictionary new];
//            [param setObject:@(vm.model.uid) forKey:@"uid"];
//            [DDService follow:param withBlock:^(BOOL success) {
//                if (!success) {
//                    cell.followButton.selected = !cell.followButton.selected;
//                } else {
//                }
//            }];
//            
//        }
//    }
//}


#pragma mark <PIERefreshBaseCollectionViewDelegate>
//-(void)didPullUpCollectionViewBottom:(UICollectionView *)collectionView {
//    //    [self searchMoreRemote];
//    [self searchMore];
//}

- (void)didPullRefreshUp:(UITableView *)tableView
{
    [self searchMore];
}

#pragma mark - network request (fetch data)
- (void)search{
//    if ([self.tableView.mjhf isRefreshing] == NO) {
        [self.tableView.mj_footer endRefreshing];
        _currentPage = 1;
        
        _timeStamp                 = [[NSDate date] timeIntervalSince1970];
        NSMutableDictionary* param = [NSMutableDictionary new];
        [param setObject:@(1) forKey:@"page"];
        [param setObject:@(10) forKey:@"size"];
        [param setObject:@(_timeStamp) forKey:@"last_updated"];
        [param setObject:_textToSearch forKey:@"name"];
        
        [PIESearchManager getSearchUserResult:param
                                    withBlock:^(NSMutableArray *retArray) {
                                        _notFirstLoading = YES;
                                        [_source removeAllObjects];
                                        _source = retArray;
                                        [_tableView reloadData];
                                    }];
//    }
}


- (void)searchMore {
    _currentPage ++;
    NSMutableDictionary* param = [NSMutableDictionary new];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:_textToSearch forKey:@"name"];
    [PIESearchManager getSearchUserResult:param withBlock:^(NSMutableArray *retArray) {
        [_source addObjectsFromArray: retArray];
        [_tableView reloadData];
        if (retArray.count<=0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - <UICollectionViewDataSource>

//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return _source.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _source.count;
}

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//        PIEUserViewModel* vm = [_source objectAtIndex:indexPath.row];
//        if (vm.replyPages.count<=0) {
//            PIESearchUserSimpleCollectionCell *cell =
//            (PIESearchUserSimpleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PIESearchUserSimpleCollectionCell"
//                                                                                           forIndexPath:indexPath];
//            [cell injectSauce:[_source objectAtIndex:indexPath.row]];
//            return cell;
//        } else {
//            PIESearchUserCollectionViewCell *cell =
//            (PIESearchUserCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PIESearchUserCollectionViewCell"
//                                                                                         forIndexPath:indexPath];
//            [cell injectSauce:[_source objectAtIndex:indexPath.row]];
//            return cell;
//        }
//        
//    return nil;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PIEUserViewModel* vm = [_source objectAtIndex:indexPath.row];
    
    
    if (vm.replyPages.count <= 0) {
        /* 使用简单Cell */
        PIESearchUserSimpleTableViewCell *simpleCell =
        (PIESearchUserSimpleTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:PIESearchUserSimpleTableViewCellIdentifier forIndexPath:indexPath];
        [simpleCell injectSauce:vm];
        
        return simpleCell;
        
    }else{
        /* 使用带swipeView（作品展示）的完整Cell */
        PIESearchUserTableViewCell *cell =
        (PIESearchUserTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:PIESearchUserTableViewCellIdentifier forIndexPath:indexPath];
        
        [cell injectSauce:vm];
        
        return cell;
        
    }
 
    return nil;
}


//#pragma mark - CHTCollectionViewDelegateWaterfallLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//        if (_source.count > indexPath.row) {
//            PIEUserViewModel* vm = [_source objectAtIndex:indexPath.row];
//            if (vm.replyPages.count > 0) {
//                return CGSizeMake(SCREEN_WIDTH, 150);
//            }
//            else {
//                return CGSizeMake(SCREEN_WIDTH, 65);
//            }
//        } else {
//            return CGSizeZero;
//        }
////    else {
////        PIEPageVM* vm =[_sourceContent objectAtIndex:indexPath.row];
////        CGFloat width;
////        CGFloat height;
////        width = SCREEN_WIDTH/2 - 20;
////        height = vm.imageHeight/vm.imageWidth * width + 110;
////        height = MAX(height, 50);
////        height = MIN(height, SCREEN_HEIGHT/1.5);
////        return CGSizeMake(width, height);
////    }
//}

#pragma mark - <DZNEmptyDataSetSource & delegate>
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"抱歉！暂时没有找到你想要的！";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return _notFirstLoading;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -100;
}


#pragma mark - setters
- (void)setTextToSearch:(NSString *)textToSearch {
    _textToSearch = textToSearch;
    [self search];
}

#pragma mark - lazy loadings
- (PIERefreshTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[PIERefreshTableView alloc] init];
        
        _tableView.psDelegate = self;
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        
        /* 只可以上拉加载，不可以下拉刷新 */
        [_tableView.mj_header removeFromSuperview];
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.backgroundColor = [UIColor colorWithHex:0xF8F8F8];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        
        UINib *userSimpleCell =
        [UINib nibWithNibName:@"PIESearchUserSimpleTableViewCell"
                       bundle:nil];
        
        UINib *userCell =
        [UINib nibWithNibName:@"PIESearchUserTableViewCell"
                       bundle:nil];
        
        [_tableView registerNib:userSimpleCell
         forCellReuseIdentifier:PIESearchUserSimpleTableViewCellIdentifier];
        
        [_tableView registerNib:userCell
         forCellReuseIdentifier:PIESearchUserTableViewCellIdentifier];
        
        UITapGestureRecognizer *tapOnTableViewGesture =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(tapOnTableView:)];
        [_tableView addGestureRecognizer:tapOnTableViewGesture];
        
    }
    
    return _tableView;
}


//-(PIERefreshCollectionView *)collectionView {
//    if (!_collectionView) {
//        _collectionView = [[PIERefreshCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
//        
//        _collectionView.toRefreshTop = NO;
//        _collectionView.toRefreshBottom = YES;
//        _collectionView.psDelegate = self;
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        _collectionView.emptyDataSetDelegate = self;
//        _collectionView.emptyDataSetSource = self;
//        _collectionView.collectionViewLayout = self.layout;
//        _collectionView.backgroundColor = [UIColor colorWithHex:0xF8F8F8];
//        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//        
//        
//        UINib* nib = [UINib nibWithNibName:@"PIESearchUserCollectionViewCell" bundle:nil];
//        [_collectionView registerNib:nib forCellWithReuseIdentifier:@"PIESearchUserCollectionViewCell"];
//        
//        UINib* nib3 = [UINib nibWithNibName:@"PIESearchUserSimpleCollectionCell" bundle:nil];
//        [_collectionView registerNib:nib3 forCellWithReuseIdentifier:@"PIESearchUserSimpleCollectionCell"];
//        
//        
//        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnCollectionView:)];
//        [_collectionView addGestureRecognizer:tapGesture];
//    }
//    return _collectionView;
//}
//

//-(CHTCollectionViewWaterfallLayout *)layout {
//    if (_layout == nil) {
//        _layout = [[CHTCollectionViewWaterfallLayout alloc] init];
//        _layout.columnCount = 1;
//        _layout.minimumInteritemSpacing = 1;
//        _layout.minimumColumnSpacing = 0;
//        _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        
//    }
//    return _layout;
//}
@end
