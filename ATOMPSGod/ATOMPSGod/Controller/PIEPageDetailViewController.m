//
//  PIEPageDetailViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 2/19/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEPageDetailViewController.h"
#import "PIEPageDetailHeaderTableViewCell.h"
#import "PIECommentTableCell.h"
#import "PIECommentManager.h"
@interface PIEPageDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *commentSourceArray;

@end

@implementation PIEPageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    _commentSourceArray = [NSMutableArray array];
    [self getDataSource];
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
    
//    _canRefreshFooter = NO;
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 20;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        label.text = @"评论";
        return label;
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
        return cell;
    } else if (section == 1) {
        PIECommentTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommentTableCellReuseIdentifier"];
        [cell getSource:_commentSourceArray[indexPath.row]];
        return cell;
    }
    return nil;

}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 400;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        UINib *nib = [UINib nibWithNibName:@"PIEPageDetailHeaderTableViewCell" bundle:NULL];
        [_tableView registerNib:nib forCellReuseIdentifier:@"PageDetailHeaderTableViewCellIdentifier"];
        [_tableView registerClass:[PIECommentTableCell class] forCellReuseIdentifier:@"CommentTableCellReuseIdentifier"];

    }
    return _tableView;
}


#pragma mark - GetDataSource

- (void)getDataSource {
    
//    _currentPage = 1;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_pageViewModel.ID) forKey:@"target_id"];
    [param setObject:@(_pageViewModel.type) forKey:@"type"];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    
    PIECommentManager *commentManager = [PIECommentManager new];
    [commentManager ShowDetailOfComment:param withBlock:^(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error) {
        self.commentSourceArray = recentCommentArray;
        
//        if (recentCommentArray.count > 0) {
//            _canRefreshFooter = YES;
//        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)getMoreDataSource {
//    WS(ws);
////    _currentPage++;
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:@(_pageViewModel.ID) forKey:@"target_id"];
//    [param setObject:@(_pageViewModel.type) forKey:@"type"];
////    [param setObject:@(_currentPage) forKey:@"page"];
//    [param setObject:@(10) forKey:@"size"];
//    PIECommentManager *commentManager = [PIECommentManager new];
//    [commentManager ShowDetailOfComment:param withBlock:^(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error) {
//        [self.source_newComment willChangeValueForKey:@"array"];
//        [ws.source_newComment addArrayObject: recentCommentArray];
//        [self.source_newComment didChangeValueForKey:@"array"];
//        [ws.source_hotComment addObjectsFromArray: hotCommentArray];
//        
//        [self.tableView.mj_footer endRefreshing];
//        [self.tableView reloadData];
//        if (recentCommentArray.count == 0) {
//            ws.canRefreshFooter = NO;
//        } else {
//            ws.canRefreshFooter = YES;
//        }
//    }];
}

@end
