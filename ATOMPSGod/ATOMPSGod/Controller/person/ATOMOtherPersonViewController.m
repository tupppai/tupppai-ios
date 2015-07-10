//
//  ATOMOtherPersonViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMOtherPersonViewController.h"
#import "ATOMOtherPersonView.h"
#import "ATOMMyWorkCollectionViewCell.h"
#import "ATOMMyUploadCollectionViewCell.h"
#import "ATOMMyFansViewController.h"
#import "ATOMOtherPersonConcernViewController.h"
#import "ATOMHotDetailViewController.h"
#import "ATOMOtherPersonCollectionHeaderView.h"
#import "ATOMShowOtherUser.h"
#import "ATOMHomeImage.h"
#import "ATOMAskPageViewModel.h"
#import "ATOMAskViewModel.h"
#import "ATOMReplyViewModel.h"
#import "ATOMPageDetailViewController.h"
#import "ATOMUser.h"
#import "ATOMFollowModel.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMOtherPersonViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,PWRefreshBaseCollectionViewDelegate>

@property (nonatomic, strong) ATOMOtherPersonView *otherPersonView;
@property (nonatomic, strong) NSMutableArray *uploadDataSource;
@property (nonatomic, strong) NSMutableArray *workDataSource;
@property (nonatomic, strong) NSMutableArray *uploadHomeImageDataSource;
@property (nonatomic, strong) NSMutableArray *workHomeImageDataSource;
@property (nonatomic, assign) NSInteger currentUploadPage;
@property (nonatomic, assign) NSInteger currentWorkPage;
@property (nonatomic, assign) BOOL canRefreshUploadFooter;
@property (nonatomic, assign) BOOL canRefreshWorkFooter;
@property (nonatomic, assign) BOOL isFirstEnterWorkCollectionView;

@end

@implementation ATOMOtherPersonViewController

static NSString *UploadCellIdentifier = @"OtherPersonUploadCell";
static NSString *WorkCellIdentifier = @"OtherPersonWorkCell";

#pragma mark - Refresh

//- (void)configCollectionViewRefresh {
//    [_otherPersonView.scrollView.otherPersonUploadCollectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreUploadData)];
//    [_otherPersonView.scrollView.otherPersonWorkCollectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreWorkData)];
//}

- (void)loadMoreUploadData {
    if (_canRefreshUploadFooter) {
        [self getMoreDataSourceWithType:@"upload"];
    } else {
        [_otherPersonView.scrollView.otherPersonUploadCollectionView.footer endRefreshing];
    }
}

- (void)loadMoreWorkData {
    if (_canRefreshWorkFooter) {
        [self getMoreDataSourceWithType:@"work"];
    } else {
        [_otherPersonView.scrollView.otherPersonWorkCollectionView.footer endRefreshing];
    }
    
}
#pragma mark - PWRefreshBaseCollectionViewDelegate
-(void)didPullUpCollectionViewBottom:(PWRefreshFooterCollectionView *)collectionView {
    if (collectionView == _otherPersonView.scrollView.otherPersonUploadCollectionView) {
        [self loadMoreUploadData];
    }else if (collectionView == _otherPersonView.scrollView.otherPersonWorkCollectionView) {
        [self loadMoreWorkData];
    }
}
#pragma mark - GetDataSource

- (void)getDataSourceWithType:(NSString *)type {
    //目前的接口是ask和reply一起返回
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_userID) forKey:@"uid"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];

        _uploadDataSource = nil;
        _uploadDataSource = [NSMutableArray array];
        _uploadHomeImageDataSource = nil;
        _uploadHomeImageDataSource = [NSMutableArray array];
        _currentUploadPage = 1;
        [param setObject:@(_currentUploadPage) forKey:@"page"];
//        [param setObject:@(ATOMPageTypeAsk) forKey:@"type"];
    
        _workDataSource = nil;
        _workDataSource = [NSMutableArray array];
        _workHomeImageDataSource = nil;
        _workHomeImageDataSource = [NSMutableArray array];
        _currentWorkPage = 1;
//        [param setObject:@(_currentWorkPage) forKey:@"page"];
//        [param setObject:@(ATOMPageTypeReply) forKey:@"type"];

    [Util loadingHud:@"" inView:self.view];
    [ATOMShowOtherUser ShowOtherUser:param withBlock:^(NSMutableArray *askReturnArray, NSMutableArray *replyReturnArray, ATOMUser *user, NSError *error) {
        [Util dismissHud:self.view];
        if (error) {
            [Util TextHud:@"出现未知错误" inView:self.view];
        } else {
            if (user) {
                [self updateUserInterface:user];
            }
            for (ATOMHomeImage *homeImage in askReturnArray) {
                ATOMAskPageViewModel *homepageViewModel = [ATOMAskPageViewModel new];
                [homepageViewModel setViewModelData:homeImage];
                ATOMAskViewModel *askViewModel = [ATOMAskViewModel new];
                [askViewModel setViewModelData:homeImage];
                [ws.uploadDataSource addObject:askViewModel];
                [ws.uploadHomeImageDataSource addObject:homepageViewModel];
            }
            for (ATOMHomeImage *homeImage in replyReturnArray) {
                ATOMAskPageViewModel *homepageViewModel = [ATOMAskPageViewModel new];
                [homepageViewModel setViewModelData:homeImage];
                ATOMReplyViewModel *replyViewModel = [ATOMReplyViewModel new];
                [replyViewModel setViewModelData:homeImage];
                [ws.workDataSource addObject:replyViewModel];
                [ws.workHomeImageDataSource addObject:homepageViewModel];
            }
        }
        if (ws.otherPersonView.scrollView.currentType == ATOMOtherPersonCollectionViewTypeAsk) {
            [ws.otherPersonView.scrollView.otherPersonUploadCollectionView reloadData];
            [ws.otherPersonView.scrollView.otherPersonUploadCollectionView.footer endRefreshing];
            if (askReturnArray.count == 0) {
                ws.canRefreshUploadFooter = NO;
            } else {
                ws.canRefreshUploadFooter = YES;
            }
        } else if (ws.otherPersonView.scrollView.currentType == ATOMOtherPersonCollectionViewTypeReply) {
            [ws.otherPersonView.scrollView.otherPersonWorkCollectionView reloadData];
            [ws.otherPersonView.scrollView.otherPersonWorkCollectionView.footer endRefreshing];
            if (replyReturnArray.count == 0) {
                ws.canRefreshWorkFooter = NO;
            } else {
                ws.canRefreshWorkFooter = YES;
            }
        }
    }];
}

- (void)getMoreDataSourceWithType:(NSString *)type {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_userID) forKey:@"uid"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
//    if ([type isEqualToString:@"upload"]) {
        _currentUploadPage++;
        [param setObject:@(_currentUploadPage) forKey:@"page"];
//        [param setObject:@(ATOMPageTypeAsk) forKey:@"type"];
//    } else if ([type isEqualToString:@"work"]) {
        _currentWorkPage++;
//        [param setObject:@(_currentWorkPage) forKey:@"page"];
//        [param setObject:@(ATOMPageTypeReply) forKey:@"type"];
//    }
//    [param setObject:@"time" forKey:@"sort"];
//    [param setObject:@"desc" forKey:@"order"];
    [ATOMShowOtherUser ShowOtherUser:param withBlock:^(NSMutableArray *askReturnArray, NSMutableArray *replyReturnArray, ATOMUser *user, NSError *error) {
        if (error) {
            [Util TextHud:@"出现未知错误" inView:self.view];
        } else {
            if (user) {
                [self updateUserInterface:user];
            }
            for (ATOMHomeImage *homeImage in askReturnArray) {
                ATOMAskPageViewModel *homepageViewModel = [ATOMAskPageViewModel new];
                [homepageViewModel setViewModelData:homeImage];
                    ATOMAskViewModel *askViewModel = [ATOMAskViewModel new];
                    [askViewModel setViewModelData:homeImage];
                    [ws.uploadDataSource addObject:askViewModel];
                    [ws.uploadHomeImageDataSource addObject:homepageViewModel];
            }
            for (ATOMHomeImage *homeImage in replyReturnArray) {
                ATOMAskPageViewModel *homepageViewModel = [ATOMAskPageViewModel new];
                [homepageViewModel setViewModelData:homeImage];
                    ATOMReplyViewModel *replyViewModel = [ATOMReplyViewModel new];
                    [replyViewModel setViewModelData:homeImage];
                    [ws.workDataSource addObject:replyViewModel];
                    [ws.workHomeImageDataSource addObject:homepageViewModel];
            }
        }
        if (ws.otherPersonView.scrollView.currentType == ATOMOtherPersonCollectionViewTypeAsk) {
            [ws.otherPersonView.scrollView.otherPersonUploadCollectionView reloadData];
            [ws.otherPersonView.scrollView.otherPersonUploadCollectionView.footer endRefreshing];
            if (askReturnArray.count == 0) {
                ws.canRefreshUploadFooter = NO;
            } else {
                ws.canRefreshUploadFooter = YES;
            }
        } else if (ws.otherPersonView.scrollView.currentType == ATOMOtherPersonCollectionViewTypeReply) {
            [ws.otherPersonView.scrollView.otherPersonWorkCollectionView reloadData];
            [ws.otherPersonView.scrollView.otherPersonWorkCollectionView.footer endRefreshing];
            if (replyReturnArray.count == 0) {
                ws.canRefreshWorkFooter = NO;
            } else {
                ws.canRefreshWorkFooter = YES;
            }
        }
    }];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = _userName;
    _otherPersonView = [ATOMOtherPersonView new];
    self.view = _otherPersonView;
    _otherPersonView.scrollView.delegate = self;
    _otherPersonView.scrollView.otherPersonUploadCollectionView.delegate = self;
    _otherPersonView.scrollView.otherPersonUploadCollectionView.dataSource = self;
    _otherPersonView.scrollView.otherPersonUploadCollectionView.psDelegate = self;

    _otherPersonView.scrollView.otherPersonWorkCollectionView.delegate = self;
    _otherPersonView.scrollView.otherPersonWorkCollectionView.dataSource = self;
    _otherPersonView.scrollView.otherPersonWorkCollectionView.psDelegate = self;
    
    [_otherPersonView.uploadHeaderView.attentionButton addTarget:self action:@selector(tapFollowButton) forControlEvents:UIControlEventTouchUpInside];
    [self registerCollection];
    [self addTargetToOtherPersonView:_otherPersonView.uploadHeaderView];
    _canRefreshUploadFooter = YES;
    _canRefreshWorkFooter = YES;
    _isFirstEnterWorkCollectionView = YES;
    [self getDataSourceWithType:@"upload"];
    
    if (_userID == [ATOMCurrentUser currentUser].uid) {
        _otherPersonView.uploadHeaderView.attentionButton.hidden = YES;
    }
}

-(void)updateUserInterface:(ATOMUser*)user {
    NSURL* avatarURL = [[NSURL alloc]initWithString:user.avatar];
    [_otherPersonView.uploadHeaderView.userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:avatarURL];
    _otherPersonView.uploadHeaderView.attentionButton.selected = user.isMyFollow;
    _otherPersonView.uploadHeaderView.userSexImageView.image = user.sex == 1 ? [UIImage imageNamed:@"gender_male"]:[UIImage imageNamed:@"gender_female"];
    _otherPersonView.uploadHeaderView.attentionLabel.attributedText = [self getAttributeStr:@"关注" withNumber:user.attentionNumber];
    _otherPersonView.uploadHeaderView.fansLabel.attributedText = [self getAttributeStr:@"粉丝" withNumber:user.fansNumber];
    _otherPersonView.uploadHeaderView.praiseLabel.attributedText = [self getAttributeStr:@"赞" withNumber:user.praiseNumber];
    _otherPersonView.uploadHeaderView.attentionLabel.textAlignment = NSTextAlignmentCenter;
    _otherPersonView.uploadHeaderView.fansLabel.textAlignment = NSTextAlignmentCenter;
    _otherPersonView.uploadHeaderView.praiseLabel.textAlignment = NSTextAlignmentCenter;
    [_otherPersonView.uploadHeaderView.otherPersonUploadButton setTitle:[NSString stringWithFormat:@"求P（%ld）",user.uploadNumber] forState:UIControlStateNormal];
    [_otherPersonView.uploadHeaderView.otherPersonWorkButton setTitle:[NSString stringWithFormat:@"作品（%ld）",user.replyNumber] forState:UIControlStateNormal];
}
-(NSMutableAttributedString*)getAttributeStr:(NSString*)desc withNumber:(NSInteger)number {
    NSString *numberStr = [NSString stringWithFormat:@"%ld",number];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 6;
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:kFont14], NSFontAttributeName, [UIColor colorWithHex:0x74c3ff], NSForegroundColorAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    NSMutableAttributedString *fansStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", numberStr,desc] attributes:attributeDict];
    NSInteger descCount = desc.length;
    [fansStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, [UIColor colorWithHex:0xc3cbd2], NSForegroundColorAttributeName, nil] range:NSMakeRange(numberStr.length + 1, descCount)];
    return fansStr;
}
- (void)addTargetToOtherPersonView:(ATOMOtherPersonCollectionHeaderView *)headerView {
    [headerView.otherPersonUploadButton addTarget:self action:@selector(clickAskButton:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.otherPersonWorkButton addTarget:self action:@selector(clickReplyButton:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapConcernGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapConcernGesture:)];
    [headerView.attentionLabel addGestureRecognizer:tapConcernGesture];
    
    UITapGestureRecognizer *tapFansGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFansGesture:)];
    [headerView.fansLabel addGestureRecognizer:tapFansGesture];
}

- (void)registerCollection {
    [_otherPersonView.scrollView.otherPersonUploadCollectionView registerClass:[ATOMMyUploadCollectionViewCell class] forCellWithReuseIdentifier:UploadCellIdentifier];
    [_otherPersonView.scrollView.otherPersonWorkCollectionView registerClass:[ATOMMyWorkCollectionViewCell class] forCellWithReuseIdentifier:WorkCellIdentifier];
}

#pragma mark - Click Event

- (void)clickAskButton:(UIButton *)sender {
    [_otherPersonView.uploadHeaderView toggleSegmentBar:ATOMOtherPersonCollectionViewTypeAsk];
    [_otherPersonView.scrollView toggleCollectionView:ATOMOtherPersonCollectionViewTypeAsk];
}

- (void)clickReplyButton:(UIButton *)sender {
    [_otherPersonView.uploadHeaderView toggleSegmentBar:ATOMOtherPersonCollectionViewTypeReply];
    [_otherPersonView.scrollView toggleCollectionView:ATOMOtherPersonCollectionViewTypeReply];
//    if (_isFirstEnterWorkCollectionView) {
//        _isFirstEnterWorkCollectionView = NO;
//        [self getDataSourceWithType:@"work"];
//    }
}
-(void)tapFollowButton {
    _otherPersonView.uploadHeaderView.attentionButton.selected = !_otherPersonView.uploadHeaderView.attentionButton.selected;
    NSDictionary* param = [[NSDictionary alloc]initWithObjectsAndKeys:@(_userID),@"uid", nil];
    [ATOMFollowModel follow:param withType:_otherPersonView.uploadHeaderView.attentionButton.selected withBlock:^(NSError *error) {
        if (error) {
            [Util TextHud:@"出现未知错误" inView:self.view];
            _otherPersonView.uploadHeaderView.attentionButton.selected = !_otherPersonView.uploadHeaderView.attentionButton.selected;
        } else {
            NSString* desc = _otherPersonView.uploadHeaderView.attentionButton.selected?[NSString stringWithFormat:@"你关注了%@",_userName]:[NSString stringWithFormat:@"你取消关注了%@",_userName];
            [Util TextHud:desc inView:self.view];
        }
    }];
}

#pragma mark - Gesture Event

- (void)tapConcernGesture:(UITapGestureRecognizer *)gesture {
    ATOMOtherPersonConcernViewController *opvcv = [ATOMOtherPersonConcernViewController new];
    opvcv.uid = _userID;
    opvcv.userName = _userName;
    [self pushViewController:opvcv animated:YES];
}

- (void)tapFansGesture:(UITapGestureRecognizer *)gesture {
    ATOMMyFansViewController *mfvc = [ATOMMyFansViewController new];
    mfvc.uid = _userID;
    mfvc.userName = _userName;
    [self pushViewController:mfvc animated:YES];
}

//#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = -44;
//    CGFloat originHeight = -300;
//    if (scrollView == _otherPersonView.scrollView.otherPersonUploadCollectionView) {
//        CGRect frame = _otherPersonView.uploadHeaderView.frame;
//        if (scrollView.contentOffset.y >= originHeight && scrollView.contentOffset.y < sectionHeaderHeight) {
//            frame.origin.y = originHeight - scrollView.contentOffset.y;
//            [UIView animateWithDuration:0.25 animations:^{
//                _otherPersonView.uploadHeaderView.frame = frame;
//               scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//            }];
//        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
//            frame.origin.y = originHeight - sectionHeaderHeight;
//            [UIView animateWithDuration:0.25 animations:^{
//                _otherPersonView.uploadHeaderView.frame = frame;
//                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//            }];
//        }
//    } else if (scrollView == _otherPersonView.scrollView.otherPersonWorkCollectionView) {
////        CGRect frame = _otherPersonView.workHeaderView.frame;
//        if (scrollView.contentOffset.y >= originHeight && scrollView.contentOffset.y < sectionHeaderHeight) {
////            frame.origin.y = originHeight - scrollView.contentOffset.y;
//            [UIView animateWithDuration:0.25 animations:^{
////                _otherPersonView.workHeaderView.frame = frame;
//                scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//            }];
//        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
////            frame.origin.y = originHeight - sectionHeaderHeight;
//            [UIView animateWithDuration:0.25 animations:^{
//                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
////                _otherPersonView.workHeaderView.frame = frame;
//            }];
//        }
//    }
//
//}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_otherPersonView.scrollView.currentType == ATOMOtherPersonCollectionViewTypeAsk) {
        return _uploadDataSource.count;
    } else if (_otherPersonView.scrollView.currentType == ATOMOtherPersonCollectionViewTypeReply) {
        return _workDataSource.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _otherPersonView.scrollView.otherPersonUploadCollectionView) {
        ATOMMyUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UploadCellIdentifier forIndexPath:indexPath];
        ATOMAskViewModel *model = _uploadDataSource[indexPath.row];
        [cell.workImageView setImageWithURL:[NSURL URLWithString:model.imageURL]];
        cell.totalPSNumber = model.totalPSNumber;
        cell.colorType = 0;
        return cell;
    } else {
        ATOMMyWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WorkCellIdentifier forIndexPath:indexPath];
        ATOMReplyViewModel *model = _workDataSource[indexPath.row];
        [cell.workImageView setImageWithURL:[NSURL URLWithString:model.imageURL]];
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _otherPersonView.scrollView.otherPersonUploadCollectionView) {
        ATOMAskViewModel *askViewModel = _uploadDataSource[indexPath.row];
        ATOMAskPageViewModel *homepageViewModel = _uploadHomeImageDataSource[indexPath.row];
        if ([askViewModel.totalPSNumber integerValue] == 0) {
            ATOMPageDetailViewController *rdvc = [ATOMPageDetailViewController new];
//            rdvc.delegate = self;
            PWPageDetailViewModel* pageDetailViewModel = [PWPageDetailViewModel new];
            [pageDetailViewModel setCommonViewModelWithAsk:homepageViewModel];
            rdvc.pageDetailViewModel = pageDetailViewModel;
            [self pushViewController:rdvc animated:YES];
            
        } else {
            ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
            hdvc.askPageViewModel = homepageViewModel;
            [self pushViewController:hdvc animated:YES];
        }
    } else {
        ATOMAskPageViewModel *homepageViewModel = _workHomeImageDataSource[indexPath.row];
        ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
        hdvc.askPageViewModel = homepageViewModel;
        [self pushViewController:hdvc animated:YES];
    }

}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
        int currentPage = (_otherPersonView.scrollView.contentOffset.x + CGWidth(_otherPersonView.scrollView.frame) * 0.1) / CGWidth(_otherPersonView.scrollView.frame);
        if (currentPage == 0) {
            [_otherPersonView.uploadHeaderView toggleSegmentBar:ATOMOtherPersonCollectionViewTypeAsk];
            [_otherPersonView.scrollView toggleCollectionView:ATOMOtherPersonCollectionViewTypeAsk];
        } else if (currentPage == 1) {
            [_otherPersonView.uploadHeaderView toggleSegmentBar:ATOMOtherPersonCollectionViewTypeReply];
            [_otherPersonView.scrollView toggleCollectionView:ATOMOtherPersonCollectionViewTypeReply];
//            if (_isFirstEnterWorkCollectionView) {
//                _isFirstEnterWorkCollectionView = NO;
//                [self getDataSourceWithType:@"work"];
//            }
    }
}













@end
