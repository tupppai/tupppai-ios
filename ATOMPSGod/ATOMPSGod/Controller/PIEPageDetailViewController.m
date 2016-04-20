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
#import "DDHotDetailManager.h"
#import "PIECarouselViewController3.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"

@interface PIEPageDetailViewController ()<UITableViewDataSource,UITableViewDelegate,PIEPageDetailTextInputBarDelegate,SwipeViewDelegate,SwipeViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *commentSourceArray;
@property (nonatomic,strong) UILabel *commentCountLabel;
@property (nonatomic,strong) PIEPageDetailTextInputBar *textInputBar;
@property (nonatomic, strong) MASConstraint *inputBarHC;
@property (nonatomic, strong) MASConstraint *inputbarBottomMarginHC;

@property (nonatomic, strong) PIECommentVM *targetCommentVM;

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) long long timeStamp;

@property (nonatomic,strong) NSArray *replySourceArray;
@property (nonatomic,strong) NSArray *askSourceArray;
@property (nonatomic,strong) PIEPageCollectionSwipeView *collectionSwipeView;

@end

@implementation PIEPageDetailViewController

-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupNav];
    [self setupData];
    [self setupViews];
    [self registerObservers];
    [self setupActions];
    [self getCommentSource];
    [self getPageCollectionSwipeViewDataSource];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupNav {
    UIButton *buttonLeft = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    buttonLeft.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [buttonLeft setImage:[UIImage imageNamed:@"PIE_icon_back"] forState:UIControlStateNormal];
    
    if (self.navigationController.viewControllers.count == 1) {
        [buttonLeft addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }   else {
        [buttonLeft addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem =  buttonItem;
}
- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setupViews {
    [self.view addSubview:self.tableView];
    
    /*
        新需求：游客态则隐藏textInputBar
     */
    if ([DDUserManager currentUser].uid != kPIETouristUID) {
        [self.view addSubview:self.textInputBar];
        [self.textInputBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.trailing.equalTo(self.view);
            self.inputbarBottomMarginHC = make.bottom.equalTo(self.view);
            self.inputBarHC = make.height.equalTo(@(self.textInputBar.appropriateHeight));
        }];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.textInputBar.appropriateHeight, 0);
    }
    
    [self setupTableViewRefreshingFooter];
}

- (void)setupTableViewRefreshingFooter {
    
    NSMutableArray *animatedImages = [NSMutableArray array];
    for (int i = 1; i<=6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pie_loading_%d", i]];
        [animatedImages addObject:image];
    }
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreCommentSource)];
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
    
    [footer setImages:animatedImages duration:0.5 forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_footer = footer;
    
}

- (void)setupData {
    _commentSourceArray = [NSMutableArray array];
    _replySourceArray = [NSMutableArray array];
    _askSourceArray = [NSMutableArray array];
}
- (void)setupActions {
    UITapGestureRecognizer *tapCommentTableGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommentTable:)];
    tapCommentTableGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapCommentTableGesture];
}

- (void)registerObservers   {
    
    [[RACObserve(self, commentSourceArray)
      filter:^BOOL(id value) {
          NSArray *array = value;
          return array.count>0;
      }]
     subscribeNext:^(id x) {
         [self.tableView reloadData];
     }];
    [[RACObserve(self, replySourceArray)
      filter:^BOOL(id value) {
          NSArray *array = value;
          return array.count>0;
      }]
     subscribeNext:^(id x) {
         if (self.collectionSwipeView.swipeView == nil) {
             return ;
         }
         [self.collectionSwipeView.swipeView reloadData];
     }];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeTextViewText:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)dealloc {
    [self unRegisterObservers];
}


- (void)unRegisterObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:NULL];
    
}

#pragma mark - getSource

- (void)getCommentSource {
    
    if (self.pageViewModel.model.totalCommentNumber == 0) {
        return;
    }
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

- (void)getMoreCommentSource {
    if (self.pageViewModel.model.totalCommentNumber == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    self.currentPage++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_pageViewModel.ID) forKey:@"target_id"];
    [param setObject:@(_pageViewModel.type) forKey:@"type"];
    [param setObject:@(self.currentPage) forKey:@"page"];
    if (self.timeStamp == 0) {
        self.timeStamp = [[NSDate date] timeIntervalSince1970];
        [param setObject:@(self.timeStamp) forKey:@"last_updated"];
    } else {
        [param setObject:@(self.timeStamp) forKey:@"last_updated"];
    }
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

- (void)getPageCollectionSwipeViewDataSource {
    if (self.pageViewModel.askID == 0) {
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(100) forKey:@"size"];
    DDHotDetailManager *manager = [DDHotDetailManager new];
    [manager fetchAllReply:param ID:_pageViewModel.askID withBlock:^(NSMutableArray *askArray, NSMutableArray *replyArray) {
        self.askSourceArray = askArray;
        self.collectionSwipeView.askSourceArray = askArray;
        
        NSMutableArray *KVCArray = [self mutableArrayValueForKey:@"replySourceArray"];
        [KVCArray addObjectsFromArray:replyArray];
    }];
    
}
#pragma mark - tapCommentTable

- (void)tapCommentTable:(UITapGestureRecognizer *)gesture {
    
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath == nil) {
        return;
    }
    if (indexPath.section == 0) {
        
        // present JITImageViewController
        PIEPageDetailHeaderTableViewCell *headerCell =
        [self.tableView cellForRowAtIndexPath:indexPath];
        
        JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
        imageInfo.image =
        headerCell.blurAnimateImageView.imageView.image;
        
        imageInfo.referenceRect = headerCell.frame;
        imageInfo.referenceView = self.tableView;
        imageInfo.referenceContentMode = UIViewContentModeScaleAspectFit;
        
        JTSImageViewController *imageViewVC =
        [[JTSImageViewController alloc]
         initWithImageInfo:imageInfo
         mode:JTSImageViewControllerMode_Image
         backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
        
        [imageViewVC showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
        
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
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }
        
    }
}


#pragma mark - tableView dataSource & delegate

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
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPageCollectionSwipeView_askImageView1)];
        UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPageCollectionSwipeView_askImageView2)];
        
        [cell.pageCollectionSwipeView.askImageView addGestureRecognizer:tapGesture];
        [cell.pageCollectionSwipeView.askImageView2 addGestureRecognizer:tapGesture2];
        cell.pageCollectionSwipeView.swipeView.delegate = self;
        cell.pageCollectionSwipeView.swipeView.dataSource = self;
        self.collectionSwipeView = cell.pageCollectionSwipeView;
        
        return cell;
        
    } else if (section == 1) {
        PIEPageCommentTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PageCommentTableViewCellResueIdentifier"];
        [cell getSource:_commentSourceArray[indexPath.row]];
        return cell;
    }
    return nil;

}

#pragma mark SwipeView delegate&datasource


- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    
    return _replySourceArray.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    CGFloat swipeViewHeight = swipeView.frame.size.height;

    if (!view)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 1, swipeViewHeight+5, swipeViewHeight)];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, swipeViewHeight, swipeViewHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        imageView.clipsToBounds = YES;
        [view addSubview:imageView];
    }
    PIEPageVM* vm = [_replySourceArray objectAtIndex:index];
    for (UIView *subView in view.subviews){
        if([subView isKindOfClass:[UIImageView class]]){
            UIImageView *imageView = (UIImageView *)subView;
            vm.imageURL = [vm.imageURL trimToImageWidth:swipeViewHeight*SCREEN_SCALE];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[vm.imageURL trimToImageWidth:swipeViewHeight*SCREEN_SCALE]]];
        }
    }
    if (index == 0) {
        UIImageView *tagImageView = [UIImageView new];
        tagImageView.image = [UIImage imageNamed:@"pie_reply"];
        tagImageView.contentMode = UIViewContentModeScaleAspectFit;
        tagImageView.tag = 748;
        [view addSubview:tagImageView];
        [tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(view).with.offset(3);
            make.top.equalTo(view).with.offset(-1);
            make.width.equalTo(view).with.multipliedBy(0.5);
        }];
        

    } else {
        for (UIView *subView in view.subviews){
            if(subView.tag == 748){
                [subView removeFromSuperview];
            }
        }
    }
    
    return view;
}


- (void)tapPageCollectionSwipeView_askImageView1 {
//    NSLog(@"tapPageCollectionSwipeView_askImageView1 ");
//    if (_askSourceArray.count >= 1) {
//        
//    }
    [self presentCarouselVCAtIndex:0];
}
- (void)tapPageCollectionSwipeView_askImageView2 {
//    NSLog(@"tapPageCollectionSwipeView_askImageView2 ");
//    if (_askSourceArray.count >= 2) {
//        
//    }
    [self presentCarouselVCAtIndex:1];
}

-(void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    
    if (_askSourceArray.count == 1) {
        [self presentCarouselVCAtIndex:index + 1];
    }else{
        [self presentCarouselVCAtIndex:index + 2];
    }
}

- (void)presentCarouselVCAtIndex:(NSInteger)index
{
    PIECarouselViewController3 *carouselVC = [PIECarouselViewController3 new];
    
    carouselVC.pageVMs  = [self pageVMsToCarouselWithSwitchedPageVM:_pageViewModel];
    
    [self presentViewController:carouselVC animated:YES completion:nil];
    
    // 找到本页面pageVM在这个pageVMs的位置, 其对应的CarouselItemView不需要显示“详情”按钮--否则就是循环页面了
    for (int i = 0; i < carouselVC.pageVMs.count; i++) {
        if (_pageViewModel.type == carouselVC.pageVMs[i].type &&
            _pageViewModel.ID == carouselVC.pageVMs[i].ID) {
            carouselVC.hideDetailButtonIndex = i;
            break;
        }
    }
    
    [carouselVC scrollToIndex:index];
}

- (void)tapAvatar_Header {
    PIEFriendViewController *opvc = [PIEFriendViewController new];
    opvc.pageVM = self.pageViewModel;
    [self.navigationController pushViewController:opvc animated:YES];
}
- (void)tapFollow_Header {
    [self.pageViewModel follow];
}


-(void)pageDetailTextInputBar:(PIEPageDetailTextInputBar *)pageDetailTextInputBar tapRightButton:(UIButton *)tappedButton {
    [self sendComment];
}


#pragma mark methods

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



- (void)resignKeyboard {
    if ([self.textInputBar.textView isFirstResponder]) {
        [self.textInputBar.textView resignFirstResponder];
    }
}
-(void)sendComment {
    
    if (self.textInputBar.textView.text.length == 0 || [self.textInputBar.textView.text isEqualToString:@""]) {
        return;
    }
    PIECommentVM *commentVM = [PIECommentVM new];
    commentVM.username = [DDUserManager currentUser].nickname;
    commentVM.uid = [DDUserManager currentUser].uid;
    commentVM.avatar = [DDUserManager currentUser].avatar;
    commentVM.originText = self.textInputBar.textView.text;
    commentVM.time = @"刚刚";
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

#pragma mark - private helper


- (NSArray <PIEPageVM *> *)pageVMsToCarouselWithSwitchedPageVM:(PIEPageVM *)pageVM
{
    /**
     将 pageDetailVC.pageViewModel 替换到carouselVC.pageVMs[index]中
     否则RAC 绑定可能绑定到两个内容相同但是内存地址不一样的两个实例上.
     */
    
    // BECAREFUL _askSourceArray == nil! 否则下面 [nil addObjectsFromArray: nonNilArray] 直接也会返回nil
    NSMutableArray<PIEPageVM *> *retArray =
    [NSMutableArray
     arrayWithArray:[_askSourceArray arrayByAddingObjectsFromArray:_replySourceArray]];
    
    // look for the duplicate pageVM, and replace it.
    for (int i = 0; i < retArray.count; i++) {
        PIEPageVM *pageVM = retArray[i];
        if (pageVM.type == _pageViewModel.type &&
            pageVM.ID == _pageViewModel.ID) {
            [retArray replaceObjectAtIndex:i withObject:_pageViewModel];
            break;
        }
    }
    
    return retArray;
}

#pragma mark - lazy initialization

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
