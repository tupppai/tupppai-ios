//
//  PIESearchViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 11/3/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIESearchViewController.h"
#import "HMSegmentedControl.h"
#import "PIESearchManager.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "PIESearchUserCollectionViewCell.h"
#import "PIESearchUserSimpleCollectionCell.h"

#import "PIESearchContentCollectionViewCell.h"
#import "PIEFriendViewController.h"
#import "PIECarouselViewController2.h"
#import "PIEUserViewModel.h"
@interface PIESearchViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *verticalLine;

@property (nonatomic, strong) UITextField *textField2;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


@property (nonatomic, strong) NSMutableArray* sourceUser;
@property (nonatomic, strong) NSMutableArray* sourceContent;
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *layout;
@property (nonatomic, assign) NSInteger lastIndex;
@property (nonatomic, strong) NSString *lastSearchKeyword;

//has to set isFirstLoading to be Yes in first place before call network requst, use notFirstLoading instead to avoid this;

@property (nonatomic, assign) BOOL notFirstLoading;
@property (nonatomic, assign) BOOL notFirstShowKeyboard;

@end

@implementation PIESearchViewController

-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_notFirstShowKeyboard) {
        [_textField2 becomeFirstResponder];
        _notFirstShowKeyboard = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;    
    _sourceUser = [NSMutableArray new];
    _sourceContent = [NSMutableArray new];
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        self.edgesForExtendedLayout = UIRectEdgeAll;
//    }
    
    [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* searchView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    searchView.image = [UIImage imageNamed:@"pie_search"];
    searchView.contentMode = UIViewContentModeLeft;
    
//    _verticalLine.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.1];
    _segmentedControl.sectionTitles =  @[@"用户",@"内容"];
    _segmentedControl.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, [UIColor colorWithHex:0x000000 andAlpha:0.3], NSForegroundColorAttributeName, nil];
    _segmentedControl.selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, [UIColor colorWithHex:0x000000 andAlpha:0.9], NSForegroundColorAttributeName, nil];
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionIndicatorColor = [UIColor pieYellowColor];
    _segmentedControl.selectionIndicatorHeight = 4.0;
    _segmentedControl.backgroundColor = [UIColor clearColor];
    
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        if (index == 0) {
            self.layout.columnCount = 1;
            self.layout.minimumInteritemSpacing = 1;
            self.layout.minimumColumnSpacing = 0;
            _layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);

//            [_sourceUser removeAllObjects];
//            [_sourceContent removeAllObjects];
            [_collectionView reloadData];
            [self searchRemoteWithText:_textField2.text];
        }
        else {
            self.layout.columnCount = 2;
            self.layout.minimumInteritemSpacing = 10;
            self.layout.minimumColumnSpacing = 10;
            _layout.sectionInset = UIEdgeInsetsMake(10, 6, 0, 6);

//            [_sourceUser removeAllObjects];
//            [_sourceContent removeAllObjects];
            [_collectionView reloadData];
            [self searchRemoteWithText:_textField2.text];


        }
    }];
    

    
    UINib* nib = [UINib nibWithNibName:@"PIESearchUserCollectionViewCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"PIESearchUserCollectionViewCell"];
    UINib* nib2 = [UINib nibWithNibName:@"PIESearchContentCollectionViewCell" bundle:nil];
    [_collectionView registerNib:nib2 forCellWithReuseIdentifier:@"PIESearchContentCollectionViewCell"];
    UINib* nib3 = [UINib nibWithNibName:@"PIESearchUserSimpleCollectionCell" bundle:nil];
    [_collectionView registerNib:nib3 forCellWithReuseIdentifier:@"PIESearchUserSimpleCollectionCell"];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.emptyDataSetDelegate = self;
    _collectionView.emptyDataSetSource = self;
    _collectionView.collectionViewLayout = self.layout;
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnCollectionView:)];
    [_collectionView addGestureRecognizer:tapGesture];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backButton setImage:[UIImage imageNamed:@"pie_search"] forState:UIControlStateNormal];
    //    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(tapSearch) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem =  barBackButtonItem;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(tapCancel)];
    self.navigationItem.rightBarButtonItem =  rightButtonItem;
    
    _textField2 = [[UITextField alloc]initWithFrame:CGRectMake(0 , 0, SCREEN_WIDTH - 100, 30)];
    _textField2.borderStyle = UITextBorderStyleNone;
    _textField2.placeholder = @"搜索用户或内容";
    _textField2.font = [UIFont systemFontOfSize:14.0];
    self.navigationItem.titleView = _textField2;
    [_textField2 addTarget:self
                    action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];
    
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        [self.navigationController.navigationBar setBackgroundImage:nil
                                                      forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:0xfff119];
}
- (void) tapSearch {
    [self.textField2 becomeFirstResponder];
}
- (void) tapCancel {
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)tapOnCollectionView:(UITapGestureRecognizer*)gesture {
    if ([_textField2 isFirstResponder]) {
        [_textField2 resignFirstResponder];
        return;
    }

    if (_segmentedControl.selectedSegmentIndex == 1) {
        CGPoint location = [gesture locationInView:self.collectionView];
       NSIndexPath* selectedIndexPath = [self.collectionView indexPathForItemAtPoint:location];
        
        if (selectedIndexPath) {
            PIEPageVM* vm = [_sourceContent objectAtIndex:selectedIndexPath.row];
            PIESearchContentCollectionViewCell* cell = (PIESearchContentCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:selectedIndexPath];
            CGPoint p = [gesture locationInView:cell];
            if (CGRectContainsPoint(cell.avatarButton.frame, p) || CGRectContainsPoint(cell.nameLabel.frame, p)) {
                PIEFriendViewController* vc = [PIEFriendViewController new];
                vc.pageVM = vm;
                [self.navigationController pushViewController:vc animated:YES];
            } else if (CGRectContainsPoint(cell.imageView.frame, p)) {
                PIECarouselViewController2* vc = [PIECarouselViewController2 new];
                vc.pageVM = vm;
                [self.navigationController presentViewController:vc animated:YES completion:nil];
//                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else if (_segmentedControl.selectedSegmentIndex == 0) {
        CGPoint location = [gesture locationInView:self.collectionView];
        NSIndexPath* selectedIndexPath = [self.collectionView indexPathForItemAtPoint:location];
        if (selectedIndexPath) {
            PIEUserViewModel* vm = [_sourceUser objectAtIndex:selectedIndexPath.row];
            PIESearchUserCollectionViewCell* cell = (PIESearchUserCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:selectedIndexPath];
            CGPoint p = [gesture locationInView:cell];
            if (CGRectContainsPoint(cell.avatarButton.frame, p) || CGRectContainsPoint(cell.nameButton.frame, p)) {
                PIEFriendViewController* vc = [PIEFriendViewController new];
                vc.uid = vm.uid;
                vc.name = vm.username;
                [self.navigationController pushViewController:vc animated:YES];
            } else if (CGRectContainsPoint(cell.followButton.frame, p)) {
                cell.followButton.selected = !cell.followButton.selected;
                NSMutableDictionary *param = [NSMutableDictionary new];
                [param setObject:@(vm.uid) forKey:@"uid"];
                [DDService follow:param withBlock:^(BOOL success) {
                    if (!success) {
                        cell.followButton.selected = !cell.followButton.selected;
                    } else {
                    }
                }];

            }
        }

    }
}



-(CHTCollectionViewWaterfallLayout *)layout {
    if (!_layout) {
        _layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        _layout.columnCount = 1;
        _layout.minimumInteritemSpacing = 1;
        _layout.minimumColumnSpacing = 0;
        _layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);

    }
    return _layout;
}

- (void)textFieldDidChange:(UITextField*)sender {
    
    if ([_lastSearchKeyword isEqualToString: sender.text ] && _lastIndex == self.segmentedControl.selectedSegmentIndex ) {
    } else {
        [self searchRemoteWithText:sender.text];
        _lastSearchKeyword = sender.text;
        _lastIndex = self.segmentedControl.selectedSegmentIndex;
    }
}

- (void)searchRemoteWithText:(NSString*)string {
    [_sourceUser removeAllObjects];
    [_sourceContent removeAllObjects];
    if (![string isEqualToString:@""]) {
        NSMutableDictionary* param = [NSMutableDictionary new];
        if (_segmentedControl.selectedSegmentIndex == 0) {
            [param setObject:string forKey:@"name"];
            [PIESearchManager getSearchUserResult:param withBlock:^(NSMutableArray *retArray) {
                _notFirstLoading = YES;
                _sourceUser = retArray;
                [_collectionView reloadData];
            }];
        } else {
            _notFirstLoading = YES;
            [param setObject:string forKey:@"desc"];
            [PIESearchManager getSearchContentResult:param withBlock:^(NSMutableArray *retArray) {
                _sourceContent = retArray;
                [_collectionView reloadData];
            }];
        }
    }

}
- (void)dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
}




#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _sourceContent.count + _sourceUser.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
        PIEUserViewModel* vm = [_sourceUser objectAtIndex:indexPath.row];
        if (vm.replies.count<=0) {
            PIESearchUserSimpleCollectionCell *cell =
            (PIESearchUserSimpleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PIESearchUserSimpleCollectionCell"
                                                                                         forIndexPath:indexPath];
            [cell injectSauce:[_sourceUser objectAtIndex:indexPath.row]];
            return cell;
        } else {
            PIESearchUserCollectionViewCell *cell =
            (PIESearchUserCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PIESearchUserCollectionViewCell"
                                                                                         forIndexPath:indexPath];
            [cell injectSauce:[_sourceUser objectAtIndex:indexPath.row]];
            return cell;
        }

    } else {
        PIESearchContentCollectionViewCell *cell =
        (PIESearchContentCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PIESearchContentCollectionViewCell"
                                                                                     forIndexPath:indexPath];
        [cell injectSauce:[_sourceContent objectAtIndex:indexPath.row]];
        return cell;
    }
    return nil;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    PIECarouselViewController2* vc = [PIECarouselViewController2 new];
//    vc.pageVM = [_sourceDone objectAtIndex:indexPath.row];
//    DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
//    [nav pushViewController:vc animated:YES ];
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (_segmentedControl.selectedSegmentIndex == 0) {
        if (_sourceUser.count > indexPath.row) {
            PIEUserViewModel* vm = [_sourceUser objectAtIndex:indexPath.row];
            if (vm.replies.count > 0) {
                return CGSizeMake(SCREEN_WIDTH, 150);
            }
            else {
                return CGSizeMake(SCREEN_WIDTH, 65);
            }
        } else {
            return CGSizeZero;
        }
    } else {
        PIEPageVM* vm =[_sourceContent objectAtIndex:indexPath.row];
        CGFloat width;
        CGFloat height;
        width = SCREEN_WIDTH/2 - 20;
        height = vm.imageHeight/vm.imageWidth * width + 110;
        height = MAX(height, 50);
        height = MIN(height, SCREEN_HEIGHT/1.5);
        return CGSizeMake(width, height);
    }
}

#pragma mark - DZNEmptyDataSetSource & delegate
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"我们的频道很快出版咯，敬请期待～";

    if (_notFirstLoading) {
        text = @"未搜索到用户或内容";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -100;
}

@end
