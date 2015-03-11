//
//  ATOMHomepageViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHomepageViewController.h"
#import "ATOMHomePageHotTableViewCell.h"
#import "ATOMHomePageRecentTableViewCell.h"
#import "ATOMHotDetailViewController.h"
#import "ATOMUploadWorkViewController.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface ATOMHomepageViewController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *hotTitleButton;
@property (nonatomic, strong) UIButton *recentTitleButton;

@property (nonatomic, strong) UITableView *homepageHotTableView;
@property (nonatomic, strong) UITableView *homepageRecentTableView;

@property (nonatomic, strong) UIView *homepageHotView;
@property (nonatomic, strong) UIView *homepageRecentView;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) UITapGestureRecognizer *tapHomePageHotGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapHomePageRecentGesture;

@end

@implementation ATOMHomepageViewController

#pragma mark - Lazy Initialize

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [UIImagePickerController new];
    }
    return _imagePickerController;
}

- (UITableView *)homepageHotTableView {
    if (_homepageHotTableView == nil) {
        _homepageHotTableView = [[UITableView alloc] init];
        _homepageHotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homepageHotTableView.delegate = self;
        _homepageHotTableView.dataSource = self;
        _tapHomePageHotGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHomePageHotGesture:)];
        [_homepageHotTableView addGestureRecognizer:_tapHomePageHotGesture];
    }
    return _homepageHotTableView;
}

- (UITableView *)homepageRecentTableView {
    if (_homepageRecentTableView == nil) {
        _homepageRecentTableView = [[UITableView alloc] init];
        _homepageRecentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homepageRecentTableView.delegate = self;
        _homepageRecentTableView.dataSource = self;
        _tapHomePageRecentGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHomePageRecentGesture:)];
        [_homepageRecentTableView addGestureRecognizer:_tapHomePageRecentGesture];
    }
    return _homepageRecentTableView;
}

- (UIView *)homepageHotView {
    if (_homepageHotView == nil) {
        _homepageHotView = [UIView new];
        [_homepageHotView addSubview:self.homepageHotTableView];
    }
    return _homepageHotView;
}

- (UIView *)homepageRecentView {
    if (_homepageRecentView == nil) {
        _homepageRecentView = [UIView new];
        [_homepageRecentView addSubview:self.homepageRecentTableView];
    }
    return _homepageRecentView;
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)createUI {
    [self createCustomNavigationBar];
    [self changeUIAccording:@"热门"];
    _hotTitleButton.selected = YES;
}

- (void)changeUIAccording:(NSString *)buttonTitle {
    WS(ws);
    if ([buttonTitle isEqualToString:@"热门"]) {
        self.view = self.homepageHotView;
        [self.homepageHotTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    } else if ([buttonTitle isEqualToString:@"最新"]) {
        self.view = self.homepageRecentView;
        [self.homepageRecentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
}

- (void)createCustomNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]];
    UIView *customTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
//    customTitleView.backgroundColor = [UIColor orangeColor];
    self.navigationItem.titleView = customTitleView;
    _hotTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 50, 30)];
    [_hotTitleButton setTitle:@"热门" forState:UIControlStateNormal];
    [_hotTitleButton setTitleColor:[UIColor colorWithHex:0x717171] forState:UIControlStateNormal];
    [_hotTitleButton setTitleColor:[UIColor colorWithHex:0x00adef] forState:UIControlStateSelected];
    [customTitleView addSubview:_hotTitleButton];
    _recentTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_hotTitleButton.frame) +60 , 0, 50, 30)];
    [_recentTitleButton setTitle:@"最新" forState:UIControlStateNormal];
    [_recentTitleButton setTitleColor:[UIColor colorWithHex:0x717171] forState:UIControlStateNormal];
    [_recentTitleButton setTitleColor:[UIColor colorWithHex:0x00adef] forState:UIControlStateSelected];
    [customTitleView addSubview:_recentTitleButton];
    
    [_hotTitleButton addTarget:self action:@selector(clickHotTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_recentTitleButton addTarget:self action:@selector(clickRecentTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *cameraView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [cameraButton setImage:[UIImage imageNamed:@"btn_psask_normal"] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"btn_psask_pressed"] forState:UIControlStateHighlighted];
    [cameraButton setImageEdgeInsets:UIEdgeInsetsMake(5.5, 5, 5.5, 0)];
    [cameraButton addTarget:self action:@selector(clickCameraButton:) forControlEvents:UIControlEventTouchUpInside];
    [cameraView addSubview:cameraButton];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cameraView];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

#pragma mark - Click Event

- (void)clickHotTitleButton:(UIButton *)sender {
    NSLog(@"clickHotTitleButton");
    _hotTitleButton.selected = YES;
    _recentTitleButton.selected = NO;
    [self changeUIAccording:@"热门"];
}

- (void)clickRecentTitleButton:(UIButton *)sender {
    NSLog(@"clickRecentTitleButton");
    _hotTitleButton.selected = NO;
    _recentTitleButton.selected = YES;
    [self changeUIAccording:@"最新"];
}

- (void)clickCameraButton:(UIBarButtonItem *)sender {
    [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照", @"从手机相册选择", @"上传作品"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        NSString * tapTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([tapTitle isEqualToString:@"拍照"]) {
            [self dealTakingPhoto];
        } else if ([tapTitle isEqualToString:@"从手机相册选择"]) {
            [self dealSelectingPhotoFromAlbum];
        } else if ([tapTitle isEqualToString:@"上传作品"]) {
            [self dealUploadWorks];
        }
    }];
}

- (void)dealTakingPhoto {
    UIImagePickerControllerSourceType currentType = UIImagePickerControllerSourceTypeCamera;
    BOOL ok = [UIImagePickerController isSourceTypeAvailable:currentType];
    if (ok) {
        self.imagePickerController.sourceType = currentType;
        _imagePickerController.delegate = self;
        [self presentViewController:_imagePickerController animated:YES completion:NULL];
    } else {
        
    }
}


- (void)dealSelectingPhotoFromAlbum {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:_imagePickerController animated:YES completion:NULL];
}

- (void)dealUploadWorks {
    UIImagePickerControllerSourceType currentType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    BOOL ok = [UIImagePickerController isSourceTypeAvailable:currentType];
    if (ok) {
        self.imagePickerController.sourceType = currentType;
        _imagePickerController.delegate = self;
        [self presentViewController:_imagePickerController animated:YES completion:NULL];
    } else {
        
    }
}



#pragma mark - Gesture Event

- (void)tapHomePageHotGesture:(UITapGestureRecognizer *)gesture {
    if (self.view == _homepageHotView) {
        CGPoint location = [gesture locationInView:_homepageHotTableView];
        NSIndexPath *indexPath = [_homepageHotTableView indexPathForRowAtPoint:location];
        if (indexPath) {
            ATOMHomePageHotTableViewCell *cell = (ATOMHomePageHotTableViewCell *)[_homepageHotTableView cellForRowAtIndexPath:indexPath];
            CGPoint p = [gesture locationInView:cell];
            //点击图片
            if (CGRectContainsPoint([ATOMHomePageHotTableViewCell calculateHomePageHotImageViewRect:cell.userWorkImageView], p)) {
                NSLog(@"Click userWorkImageView");
                ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
                NSLog(@"current row is %d",(int)indexPath.row);
                [self pushViewController:hdvc animated:YES];
            } else if (CGRectContainsPoint(cell.topView.frame, p)) {
                p = [gesture locationInView:cell.topView];
                if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
                    NSLog(@"Click userHeaderButton");
                }
            } else {
                p = [gesture locationInView:cell.thinCenterView];
                if (CGRectContainsPoint(cell.praiseButton.frame, p)) {
                    cell.praiseButton.selected = !cell.praiseButton.selected;
                } else if (CGRectContainsPoint(cell.shareButton.frame, p)) {
                    NSLog(@"Click shareButton");
                }
            }
            
        }
    } else if (self.view == _homepageRecentView) {
        
    } else {
        
    }
    
}

- (void)tapHomePageRecentGesture:(UITapGestureRecognizer *)gesture {
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    WS(ws);
    [self dismissViewControllerAnimated:YES completion:^{
        ATOMUploadWorkViewController *uwvc = [ATOMUploadWorkViewController new];
        uwvc.originImage = info[UIImagePickerControllerOriginalImage];
        [ws pushViewController:uwvc animated:YES];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"current section is %d and current row is %d", (int)indexPath.section, (int)indexPath.row);
    if (tableView == _homepageHotTableView) {
        static NSString *CellIdentifier1 = @"HomePageHotCell";
        ATOMHomePageHotTableViewCell *cell = [_homepageHotTableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (!cell) {
            cell = [[ATOMHomePageHotTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
//            [cell.userHeaderButton addTarget:self action:@selector(clickUserHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        [cell layoutSubviews];
        return cell;
    } else if (tableView == _homepageRecentTableView) {
        static NSString *CellIdentifier2 = @"HomePageRecentCell";
        ATOMHomePageRecentTableViewCell *cell = [_homepageRecentTableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (!cell) {
            cell = [[ATOMHomePageRecentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
//            [cell.userHeaderButton addTarget:self action:@selector(clickUserHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        [cell layoutSubviews];
        return cell;
    } else {
        return nil;
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _homepageHotTableView) {
        return [ATOMHomePageHotTableViewCell calculateCellHeight];
    } else if (tableView == _homepageRecentTableView) {
        return [ATOMHomePageRecentTableViewCell calculateCellHeight];
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _homepageHotTableView) {
    } else if (tableView == _homepageRecentTableView) {
    } else {
    }
}


























@end
