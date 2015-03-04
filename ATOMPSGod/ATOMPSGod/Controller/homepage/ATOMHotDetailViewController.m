//
//  ATOMHotDetailViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHotDetailViewController.h"
#import "ATOMHotDetailTableViewCell.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface ATOMHotDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *hotDetailView;
@property (nonatomic, strong) UITableView *hotDetailTableView;

@end

@implementation ATOMHotDetailViewController

#pragma mark - Lazy Initialize

- (UITableView *)hotDetailTableView {
    if (_hotDetailTableView == nil) {
        _hotDetailTableView = [[UITableView alloc] init];
        _hotDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _hotDetailTableView.delegate = self;
        _hotDetailTableView.dataSource = self;
    }
    return _hotDetailTableView;
}

- (UIView *)hotDetailView {
    if (_hotDetailView == nil) {
        _hotDetailView = [UIView new];
        [_hotDetailView addSubview:self.hotDetailTableView];
    }
    return _hotDetailView;
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    WS(ws);
    self.title = @"详情";
    self.view = self.hotDetailView;
    [self.hotDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - Click Event

#pragma mark - UIImagePickerControllerDelegate


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"HotDetailCell";
    ATOMHotDetailTableViewCell *cell = [_hotDetailTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMHotDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ATOMHotDetailTableViewCell calculateCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



@end
