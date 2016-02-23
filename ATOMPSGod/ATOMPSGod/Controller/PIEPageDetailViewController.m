//
//  PIEPageDetailViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 2/19/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEPageDetailViewController.h"
#import "PIEPageDetailHeaderTableViewCell.h"
#import "PIEPageCommentTableViewCell.h"
#import "PIECommentManager.h"
#import "PIECommentTableViewHeader.h"
#import "PIEPageDetailTextInputBar.h"
#import "LeesinTextView.h"
#import "PIEEntityCommentReply.h"
#import "PIEFriendViewController.h"
#import "PIEAvatarButton.h"
#import "PIEBlurAnimateImageView.h"
#import "SwipeView.h"
#import "PIEPageCollectionSwipeView.h"
@interface PIEPageDetailViewController ()<UITableViewDataSource,UITableViewDelegate,PIEPageDetailTextInputBarDelegate,SwipeViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *commentSourceArray;
@property (nonatomic,strong) UILabel *commentCountLabel;
@property (nonatomic,strong) PIEPageDetailTextInputBar *textInputBar;
@property (nonatomic, strong) MASConstraint *inputBarHC;
@property (nonatomic, strong) MASConstraint *inputbarBottomMarginHC;

@property (nonatomic, strong) PIECommentVM *targetCommentVM;

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) long long timeStamp;

@end

@implementation PIEPageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.textInputBar];
    [self.textInputBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.equalTo(self.view);
        self.inputbarBottomMarginHC = make.bottom.equalTo(self.view);
        self.inputBarHC = make.height.equalTo(@(self.textInputBar.appropriateHeight));
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.textInputBar.appropriateHeight, 0);
    
    
    [self configFooterRefresh];
    
    _commentSourceArray = [NSMutableArray array];
    
    [[RACObserve(self, commentSourceArray)
      filter:^BOOL(id value) {
          NSArray *array = value;
          return array.count>0;
      }]
     subscribeNext:^(id x) {
//         [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationBottom];
         [self.tableView reloadData];
     }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeTextViewText:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tapCommentTableGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommentTable:)];
    tapCommentTableGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapCommentTableGesture];

    
    [self getDataSource];
}
-(void)dealloc {
    [self unRegisterObervers];
}

#pragma mark - tap Event

- (void)tapCommentTable:(UITapGestureRecognizer *)gesture {
    
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath == nil) {
        return;
    }
    if (indexPath.section == 0) {

    } else if (indexPath.section == 1) {
        
        NSInteger row = indexPath.row;
        PIEPageCommentTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        PIECommentVM *model =  _commentSourceArray[row];
        
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.avatarView.frame, p)) {
            PIEFriendViewController *opvc = [PIEFriendViewController new];
            PIEPageVM* vm = [[PIEPageVM alloc]initWithCommentModel:model.model];;
            opvc.pageVM = vm;
            [self.navigationController pushViewController:opvc animated:YES];
        }
        else if (CGRectContainsPoint(cell.usernameLabel.frame, p)) {
            PIEFriendViewController *opvc = [PIEFriendViewController new];
            PIEPageVM* vm = [[PIEPageVM alloc]initWithCommentModel:model.model];;
            vm.userID = model.uid;
            vm.username = model.username;
            opvc.pageVM = vm;
            [self.navigationController pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.receiveNameLabel.frame, p)) {
            PIEFriendViewController *opvc = [PIEFriendViewController new];
            opvc.uid = cell.receiveNameLabel.tag;
            [self.navigationController pushViewController:opvc animated:YES];
        } else {
            _targetCommentVM = model;
            self.textInputBar.textView.placeholder = [NSString stringWithFormat:@"@%@:",_targetCommentVM.username];
            [self.textInputBar.textView becomeFirstResponder];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
    }
}


- (void)unRegisterObervers {
 [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:NULL];
 [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:NULL];
 [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:NULL];

}

     
     
- (void)configFooterRefresh {
    
    NSMutableArray *animatedImages = [NSMutableArray array];
    for (int i = 1; i<=6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pie_loading_%d", i]];
        [animatedImages addObject:image];
    }
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
    
    [footer setImages:animatedImages duration:0.5 forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_footer = footer;
    
}

- (void)loadMoreData {
    [self getMoreDataSource];
}

-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return _commentSourceArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        PIECommentTableViewHeader *view = [PIECommentTableViewHeader new];
        view.commentCountLabel.text = [NSString stringWithFormat:@"(%zd)",self.commentSourceArray.count];
        return view;
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        PIEPageDetailHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PageDetailHeaderTableViewCellIdentifier"];
        if (_pageViewModel == nil) {
            return nil;
        }
        cell.viewModel = _pageViewModel;
        [cell.avatarButton addTarget:self action:@selector(tapAvatar_Header) forControlEvents:UIControlEventTouchDown];
        [cell.usernameButton addTarget:self action:@selector(tapAvatar_Header) forControlEvents:UIControlEventTouchDown];
        [cell.followButton addTarget:self action:@selector(tapFollow_Header) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapThumbLeftView)];
        UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapThumbRightView)];
        
        [cell.blurAnimateImageView.thumbView.leftView addGestureRecognizer:tapGesture];
        [cell.blurAnimateImageView.thumbView.rightView addGestureRecognizer:tapGesture2];
        cell.pageCollectionSwipeView.swipeView.delegate = self;

        return cell;
    } else if (section == 1) {
        PIEPageCommentTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PageCommentTableViewCellResueIdentifier"];
        [cell getSource:_commentSourceArray[indexPath.row]];
        return cell;
    }
    return nil;

}


-(void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"swipeView %zd",index);
}

- (void)tapAvatar_Header {
    PIEFriendViewController *opvc = [PIEFriendViewController new];
    opvc.pageVM = self.pageViewModel;
    [self.navigationController pushViewController:opvc animated:YES];
}
- (void)tapFollow_Header {
    [self.pageViewModel follow];
}
- (void)tapThumbLeftView {
    PIEPageDetailHeaderTableViewCell *cell  = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.blurAnimateImageView animateWithType:PIEThumbAnimateViewTypeLeft];
    
}
- (void)tapThumbRightView {
    PIEPageDetailHeaderTableViewCell *cell  = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.blurAnimateImageView animateWithType:PIEThumbAnimateViewTypeRight];
}




#pragma mark - GetDataSource

- (void)getDataSource {
    
    self.timeStamp = [[NSDate date] timeIntervalSince1970];
    self.currentPage = 1;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_pageViewModel.ID) forKey:@"target_id"];
    [param setObject:@(_pageViewModel.type) forKey:@"type"];
    [param setObject:@(self.timeStamp) forKey:@"last_updated"];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    
    PIECommentManager *commentManager = [PIECommentManager new];
    [commentManager ShowDetailOfComment:param withBlock:^(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error) {
        self.commentSourceArray = recentCommentArray;
    }];
}

- (void)getMoreDataSource {
    self.currentPage++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_pageViewModel.ID) forKey:@"target_id"];
    [param setObject:@(_pageViewModel.type) forKey:@"type"];
    [param setObject:@(self.currentPage) forKey:@"page"];
    [param setObject:@(self.timeStamp) forKey:@"last_updated"];
    [param setObject:@(10) forKey:@"size"];
    PIECommentManager *commentManager = [PIECommentManager new];
    [commentManager ShowDetailOfComment:param withBlock:^(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error) {

       
        if (recentCommentArray == nil || recentCommentArray.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            NSMutableArray *fromKVC = [self mutableArrayValueForKey:@"commentSourceArray"];
            [fromKVC addObjectsFromArray:recentCommentArray];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}


- (void)didChangeTextViewText:(id)sender {
    
    self.textInputBar.rightButton.enabled = self.textInputBar.textView.text.length > 0;
    
    if (![[sender object] isEqual: self.textInputBar.textView]) {
        return;
    }
   
    if (self.textInputBar.frame.size.height != self.textInputBar.appropriateHeight) {
        [self.inputBarHC setOffset:self.textInputBar.appropriateHeight];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.textInputBar layoutIfNeeded];
    }];
}

- (void) willShowKeyboard:(NSNotification*)notification {
    [_inputbarBottomMarginHC setOffset:-[self lsn_appropriateKeyboardHeightFromNotification:notification]];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
- (void) willHideKeyboard:(NSNotification*)notification {
    [_inputbarBottomMarginHC setOffset:0];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (CGFloat)lsn_appropriateKeyboardHeightFromNotification:(NSNotification *)notification
{
    
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    return [self lsn_appropriateKeyboardHeightFromRect:keyboardRect];
}
- (CGFloat)lsn_appropriateKeyboardHeightFromRect:(CGRect)rect
{
    CGRect keyboardRect = [self.view convertRect:rect fromView:nil];
    
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat keyboardMinY = CGRectGetMinY(keyboardRect);
    
    CGFloat keyboardHeight = MAX(0.0, viewHeight - keyboardMinY);
    
    return keyboardHeight;
}

-(void)pageDetailTextInputBar:(PIEPageDetailTextInputBar *)pageDetailTextInputBar tapRightButton:(UIButton *)tappedButton {
    [self sendComment];
}

- (void)resignKeyboard {
    if ([self.textInputBar.textView isFirstResponder]) {
        [self.textInputBar.textView resignFirstResponder];
    }
}
-(void)sendComment {
    
    PIECommentVM *commentVM = [PIECommentVM new];
    commentVM.username = [DDUserManager currentUser].nickname;
    commentVM.uid = [DDUserManager currentUser].uid;
    commentVM.avatar = [DDUserManager currentUser].avatar;
    commentVM.originText = self.textInputBar.textView.text;
    commentVM.time = @"刚刚";
    //    NSString* commentToShow;
    //回复评论
    if (_targetCommentVM) {
        [commentVM.replyArray addObjectsFromArray:_targetCommentVM.replyArray];
        commentVM.text = self.textInputBar.textView.text;
        
        PIEEntityCommentReply* reply = [PIEEntityCommentReply new];
        reply.uid = _targetCommentVM.uid;
        reply.username = _targetCommentVM.username;
        reply.text = _targetCommentVM.originText;
        reply.ID = _targetCommentVM.ID;
        [commentVM.replyArray insertObject:reply atIndex:0];
    }
    //第一次评论
    else {
        commentVM.text  = self.textInputBar.textView.text;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.commentSourceArray insertObject:commentVM atIndex:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.textInputBar.textView.text forKey:@"content"];
    [param setObject:@(_pageViewModel.type) forKey:@"type"];
    [param setObject:@(_pageViewModel.ID) forKey:@"target_id"];
    if (_targetCommentVM) {
        [param setObject:@(_targetCommentVM.ID) forKey:@"for_comment"];
    }
    PIECommentManager *showDetailOfComment = [PIECommentManager new];
    [showDetailOfComment SendComment:param withBlock:^(NSInteger comment_id, NSError *error) {
        if (comment_id) {
            commentVM.ID = comment_id;
            self.pageViewModel.model.totalCommentNumber++;
        }
    }];
    _targetCommentVM = nil;
    
    self.textInputBar.textView.text = @"";
}

-(PIEPageDetailTextInputBar *)textInputBar {
    if (!_textInputBar) {
        _textInputBar = [PIEPageDetailTextInputBar new];
        _textInputBar.delegate = self;
    }
    return _textInputBar;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 200;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UINib *nib = [UINib nibWithNibName:@"PIEPageDetailHeaderTableViewCell" bundle:NULL];
        [_tableView registerNib:nib forCellReuseIdentifier:@"PageDetailHeaderTableViewCellIdentifier"];
        [_tableView registerClass:[PIEPageCommentTableViewCell class] forCellReuseIdentifier:@"PageCommentTableViewCellResueIdentifier"];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive|UIScrollViewKeyboardDismissModeOnDrag;
        
    }
    return _tableView;
}


@end
