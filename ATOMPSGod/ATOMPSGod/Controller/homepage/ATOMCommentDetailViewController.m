//
//  ATOMCommentDetailViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/4.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCommentDetailViewController.h"
#import "ATOMCommentDetailTableViewCell.h"
#import "ATOMCommentDetailViewModel.h"
#import "ATOMCommentDetailView.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface ATOMCommentDetailViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ATOMCommentDetailView *commentDetailView;

@property (nonatomic, strong) UITapGestureRecognizer *tapCommentDetailGesture;

@property (nonatomic ,strong) NSMutableArray *dataArray;

@end

@implementation ATOMCommentDetailViewController

#pragma mark - Lazy Initialize



#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    _dataArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        ATOMCommentDetailViewModel *model = [ATOMCommentDetailViewModel new];
        if (i == 0) {
            model.isFirst = YES;
        }
        if (i % 3 == 0) {
            model.userSex = @"man";
        }
        [_dataArray addObject:model];
    }
    [_commentDetailView.commentDetailTableView reloadData];
    
}

- (void)createUI {
    self.title = @"评论详情";
    _commentDetailView = [ATOMCommentDetailView new];
    self.view = _commentDetailView;
    _commentDetailView.commentDetailTableView.delegate = self;
    _commentDetailView.commentDetailTableView.dataSource = self;
    [_commentDetailView.sendCommentButton addTarget:self action:@selector(clickSendCommentButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Click Event

- (void)clickSendCommentButton:(UIButton *)sender {
    [_commentDetailView.sendCommentView resignFirstResponder];
    NSString *commentStr = _commentDetailView.sendCommentView.text;
    _commentDetailView.sendCommentView.text = @"";
    ATOMCommentDetailViewModel *model = [ATOMCommentDetailViewModel new];
    model.userCommentDetail = commentStr;
    [_dataArray addObject:model];
    [_commentDetailView.commentDetailTableView reloadData];
}

#pragma mark - Gesture Event

//- (void)tapCommentDetailGesture:(UITapGestureRecognizer *)gesture {
//    CGPoint location = [gesture locationInView:_hotDetailTableView];
//    NSIndexPath *indexPath = [_hotDetailTableView indexPathForRowAtPoint:location];
//    if (indexPath) {
//        ATOMHotDetailTableViewCell *cell = (ATOMHotDetailTableViewCell *)[_hotDetailTableView cellForRowAtIndexPath:indexPath];
//        CGPoint p = [gesture locationInView:cell];
//        //点击图片
//        if (CGRectContainsPoint(cell.userWorkImageView.frame, p)) {
//            NSLog(@"Click userWorkImageView");
//        } else if (CGRectContainsPoint(cell.topView.frame, p)) {
//            p = [gesture locationInView:cell.topView];
//            if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
//                NSLog(@"Click userHeaderButton");
//            } else if (CGRectContainsPoint(cell.psButton.frame, p)) {
//                NSLog(@"Click psButton");
//                [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"下载素材",@"上传作品"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                    NSString *actionSheetTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
//                    if ([actionSheetTitle isEqualToString:@"下载素材"]) {
//                        [self dealDownloadWork];
//                    } else if ([actionSheetTitle isEqualToString:@"上传作品"]) {
//                        [self dealUploadWork];
//                    }
//                }];
//            }
//        } else {
//            p = [gesture locationInView:cell.thinCenterView];
//            if (CGRectContainsPoint(cell.praiseButton.frame, p)) {
//                cell.praiseButton.selected = !cell.praiseButton.selected;
//            } else if (CGRectContainsPoint(cell.shareButton.frame, p)) {
//                NSLog(@"Click shareButton");
//            }
//        }
//        
//    }
//}

#pragma mark - UIImagePickerControllerDelegate


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return _dataArray.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"HotDetailCell";
    ATOMCommentDetailTableViewCell *cell = [_commentDetailView.commentDetailTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMCommentDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSLog(@"current section is %d and current row is %d", (int)indexPath.section, (int)indexPath.row);
    if (indexPath.section == 0) {
        cell.isViewRed = YES;
        if (indexPath.row == 0) {
            cell.isFirstCell = YES;
        } else {
            cell.isFirstCell = NO;
        }
    } else if (indexPath.section ==1) {
        cell.isViewRed = NO;
        if (indexPath.row == 0) {
            cell.isFirstCell = YES;
        } else {
            cell.isFirstCell = NO;
        }
    }
    cell.viewModel = _dataArray[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ATOMCommentDetailTableViewCell calculateCellHeightWithModel:_dataArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}












@end
