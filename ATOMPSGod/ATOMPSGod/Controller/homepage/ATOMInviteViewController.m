//
//  ATOMInviteViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMInviteViewController.h"
#import "ATOMInviteView.h"
#import "InviteCell.h"
#import "ATOMInviteTableHeaderView.h"
#import "MessageViewController.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMAskPageViewModel.h"
#import "HomeViewController.h"
#import "ZZCommentHeaderView.h"
#import "ATOMInviteModel.h"
#import "ATOMInviteCellViewModel.h"
#import "ATOMFollowModel.h"
@interface ATOMInviteViewController () <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) ATOMInviteView *inviteView;
@property (nonatomic, strong) UITapGestureRecognizer *tapInviteGesture;
@property (nonatomic, strong) NSArray *datasourceRecommendMaster;
@property (nonatomic, strong) NSArray *datasourceRecommendFriends;
@property (nonatomic, assign) NSIndexPath* selectedIndexpath;

@end

@implementation ATOMInviteViewController

#pragma mark - UI

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createUI];
    [self getRecommendDataSource];
    if (_askPageViewModel) {
        _info = [[NSDictionary alloc]initWithObjectsAndKeys:@(_askPageViewModel.ID),@"ID",@(_askPageViewModel.ID),@"askID",@(_askPageViewModel.type),@"type", nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)createUI {
    self.title = @"邀请";
    if (_showNext) {
        UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
        rightButtonItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    _inviteView = [ATOMInviteView new];
    self.view = _inviteView;
    [_inviteView.wxFriendCircleInviteButton addTarget:self action:@selector(clickWXFriendCircleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_inviteView.wxFriendInviteButton addTarget:self action:@selector(clickWXFriendInviteButton:) forControlEvents:UIControlEventTouchUpInside];
    _inviteView.inviteTableView.delegate = self;
    _inviteView.inviteTableView.dataSource = self;
    _tapInviteGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInviteGesture:)];
    _tapInviteGesture.delegate = self;
    [_inviteView.inviteTableView addGestureRecognizer:_tapInviteGesture];
}

#pragma mark - Gesture Event

- (void)tapInviteGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_inviteView.inviteTableView];
    NSIndexPath *indexPath = [_inviteView.inviteTableView indexPathForRowAtPoint:location];
    _selectedIndexpath = indexPath;
    if (indexPath) {
        InviteCell *cell = (InviteCell *)[_inviteView.inviteTableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            opvc.userName = cell.viewModel.username;
            opvc.userID = cell.viewModel.uid;
            [self pushViewController:opvc animated:YES];
        } else  if (CGRectContainsPoint(cell.userNameLabel.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            [self pushViewController:opvc animated:YES];
            opvc.userName = cell.viewModel.username;
            opvc.userID = cell.viewModel.uid;
        }else if (CGRectContainsPoint(cell.inviteButton.frame, p)) {
            if (!cell.inviteButton.selected) {
                if (cell.viewModel.isFollow) {
                    [cell toggleInviteButtonAppearance];
                    [self tapInviteButton:cell.inviteButton];
                } else {
                    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"你没有关注这位大神，需要关注才能发送邀请" andMessage:nil];
                    [alertView addButtonWithTitle:@"取消"
                                             type:SIAlertViewButtonTypeDefault
                                          handler:^(SIAlertView *alert) {
                                          }];
                    [alertView addButtonWithTitle:@"邀请并关注"
                                             type:SIAlertViewButtonTypeDefault
                                          handler:^(SIAlertView *alert) {
                                              NSDictionary* param = [[NSDictionary alloc]initWithObjectsAndKeys:@(cell.viewModel.uid),@"uid", nil];
                                              [ATOMFollowModel follow:param withType:YES withBlock:nil];
                                              [cell toggleInviteButtonAppearance];
                                              [self tapInviteButton:cell.inviteButton];
                                          }];
                    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
                    [alertView show];
                }
            }
        }
    }
}
-(void)getRecommendDataSource {
    ATOMInviteModel* inviteModel = [ATOMInviteModel new];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(3) forKey:@"size"];
    [inviteModel showRecomendUsers:param withBlock:^(NSMutableArray *recommendMasters, NSMutableArray *recommendFriends, NSError *error) {
        if (recommendMasters) {
            _datasourceRecommendMaster = recommendMasters;
        }
        if (recommendFriends) {
            _datasourceRecommendFriends = recommendFriends;
        }
        [_inviteView.inviteTableView reloadData];
    }];
}
#pragma mark - Click Event

- (void)clickRightButtonItem:(UIBarButtonItem *)barButtonItem {
    
//    kfcPageVM* vm = [kfcPageVM new];
    MessageViewController* mvc = [MessageViewController new];
//    mvc.delegate = self;
    if (_askPageViewModel) {
        mvc.vm = [_askPageViewModel generatepageDetailViewModel];
    }
    HomeViewController *hvc = self.navigationController.viewControllers[0];
    [self pushViewController:mvc animated:YES];
    [self.navigationController setViewControllers:@[hvc, mvc]];
}

- (void)clickWXFriendCircleButton:(UIButton *)sender {
    NSInteger ID = [[_info objectForKey:@"ID"]integerValue];
    int type = [[_info objectForKey:@"type"]intValue];
    [self postSocialShare:ID withSocialShareType:ATOMShareTypeWechatMoments withPageType:type];
}

- (void)clickWXFriendInviteButton:(UIButton *)sender {
    NSInteger ID = [[_info objectForKey:@"ID"]integerValue];
    int type = [[_info objectForKey:@"type"]intValue];
    [self postSocialShare:ID withSocialShareType:ATOMShareTypeWechatFriends withPageType:type];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
    } else {
    return kCommentTableViewHeaderHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZZCommentHeaderView *headerView = [ZZCommentHeaderView new];
    if (section == 0) {
        headerView.titleLabel.text = @"推荐大神";
    } else if (section == 1) {
        headerView.titleLabel.text = @"推荐好友";
    }
    return headerView;
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _datasourceRecommendMaster.count;
    } else if (section == 1) {
        return _datasourceRecommendFriends.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"InviteCell";
  
    InviteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[InviteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    ATOMInviteCellViewModel * cellViewModel = [ATOMInviteCellViewModel new];
    if (indexPath.section == 0) {
        [cellViewModel setViewModelData:_datasourceRecommendMaster[indexPath.row]];
        cell.viewModel = cellViewModel;
        
    } else  if (indexPath.section == 1) {
        [cellViewModel setViewModelData:_datasourceRecommendFriends[indexPath.row]];
        cell.viewModel = cellViewModel;
    }
    return cell;
}
-(void)tapInviteButton:(id)sender {
    UIButton* button = sender;
    NSInteger askID = [[_info objectForKey:@"askID"]integerValue];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(button.tag) forKey:@"invite_uid"];
    [param setObject:@(askID) forKey:@"ask_id"];
    [ATOMInviteModel invite:param];
}
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    if([touch.view.superview isKindOfClass:[InviteCell class]]) {
//        if (_selectedIndexpath) {
//            InviteCell *cell = (InviteCell *)[_inviteView.inviteTableView cellForRowAtIndexPath:_selectedIndexpath];
//            //若已经邀请成功，就不再让inviteButton可点
//            if (CGRectContainsPoint(cell.inviteButton.frame, [touch locationInView:cell])){
//                if (cell.inviteButton.selected == YES) {
//                    return NO;
//                }
//            }
//            }
//    }
//    return YES;
//    }

@end
