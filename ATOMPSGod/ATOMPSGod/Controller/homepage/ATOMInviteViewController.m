//
//  ATOMInviteViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMInviteViewController.h"
#import "ATOMInviteView.h"
#import "ATOMInviteTableViewCell.h"
#import "ATOMInviteTableHeaderView.h"
#import "ATOMPageDetailViewController.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMAskPageViewModel.h"
#import "ATOMHomepageViewController.h"
#import "ATOMMyConcernTableHeaderView.h"
#import "ATOMInviteModel.h"
#import "ATOMInviteCellViewModel.h"
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
        ATOMInviteTableViewCell *cell = (ATOMInviteTableViewCell *)[_inviteView.inviteTableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            [self pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.inviteButton.frame, p)) {
            if (!cell.inviteButton.selected) {
                [cell toggleInviteButtonAppearance];
                [self tapInviteButton:cell.inviteButton];
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
    ATOMPageDetailViewController *rdvc = [ATOMPageDetailViewController new];
    if (_askPageViewModel) {
        rdvc.pageDetailViewModel = [_askPageViewModel generatepageDetailViewModel];
    }
    ATOMHomepageViewController *hvc = self.navigationController.viewControllers[0];
    [self pushViewController:rdvc animated:YES];
    [self.navigationController setViewControllers:@[hvc, rdvc]];
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
    ATOMMyConcernTableHeaderView *headerView = [ATOMMyConcernTableHeaderView new];
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
  
    ATOMInviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMInviteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    NSInteger askID = (NSInteger)[_info objectForKey:@"askID"];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(button.tag) forKey:@"invite_uid"];
    [param setObject:@(askID) forKey:@"ask_id"];
    [ATOMInviteModel invite:param];
}
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    if([touch.view.superview isKindOfClass:[ATOMInviteTableViewCell class]]) {
//        if (_selectedIndexpath) {
//            ATOMInviteTableViewCell *cell = (ATOMInviteTableViewCell *)[_inviteView.inviteTableView cellForRowAtIndexPath:_selectedIndexpath];
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
