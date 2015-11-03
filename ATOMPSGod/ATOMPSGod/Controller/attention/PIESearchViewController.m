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
#import "PIESearchContentCollectionViewCell.h"

@interface PIESearchViewController ()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout>
@property (weak, nonatomic) IBOutlet UIView *topContainerView;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *verticalLine;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


@property (nonatomic, strong) NSMutableArray* sourceUser;
@property (nonatomic, strong) NSMutableArray* sourceContent;
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *layout;

@end

@implementation PIESearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sourceUser = [NSMutableArray new];
    _sourceContent = [NSMutableArray new];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    
    [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* searchView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    searchView.image = [UIImage imageNamed:@"pie_search"];
    searchView.contentMode = UIViewContentModeLeft;
    
    [_textField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    _textField.leftView = searchView;
    _textField.delegate = self;
    [_textField becomeFirstResponder];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _topContainerView.backgroundColor = [UIColor colorWithHex:0xFFF119];
    _topContainerView.layer.shadowOffset = CGSizeMake(0, 1);
    _verticalLine.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.3];
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
            [_collectionView reloadData];
            [_sourceUser removeAllObjects];
            [_sourceContent removeAllObjects];
        }
        else {
            self.layout.columnCount = 2;
            [_collectionView reloadData];
            [_sourceUser removeAllObjects];
            [_sourceContent removeAllObjects];
        }
    }];
    
    

    
    UINib* nib = [UINib nibWithNibName:@"PIESearchUserCollectionViewCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"PIESearchUserCollectionViewCell"];
    UINib* nib2 = [UINib nibWithNibName:@"PIESearchContentCollectionViewCell" bundle:nil];
    [_collectionView registerNib:nib2 forCellWithReuseIdentifier:@"PIESearchContentCollectionViewCell"];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.collectionViewLayout = self.layout;
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
-(CHTCollectionViewWaterfallLayout *)layout {
    if (!_layout) {
        _layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        _layout.sectionInset = UIEdgeInsetsMake(10, 6, 0, 6);
        _layout.columnCount = 1;
    }
    return _layout;
}

- (void)textFieldDidChange:(UITextField*)sender {
    [self searchRemoteWithText:sender.text];
}
- (void)searchRemoteWithText:(NSString*)string {
    [_sourceUser removeAllObjects];
    [_sourceContent removeAllObjects];
    
    NSMutableDictionary* param = [NSMutableDictionary new];
    if (_segmentedControl.selectedSegmentIndex == 0) {
        [param setObject:string forKey:@"name"];
        [PIESearchManager getSearchUserResult:param withBlock:^(NSMutableArray *retArray) {
            _sourceUser = retArray;
            [_collectionView reloadData];
        }];
    } else {
        [param setObject:string forKey:@"desc"];
        [PIESearchManager getSearchContentResult:param withBlock:^(NSMutableArray *retArray) {
            _sourceContent = retArray;
            [_collectionView reloadData];
        }];
    }
    
}
- (void)dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"shouldChangeCharactersInRange%@",string);
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textField %@",textField.text);
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
        PIESearchUserCollectionViewCell *cell =
        (PIESearchUserCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PIESearchUserCollectionViewCell"
                                                                               forIndexPath:indexPath];
        [cell injectSauce:[_sourceUser objectAtIndex:indexPath.row]];

        return cell;
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
//    PIECarouselViewController* vc = [PIECarouselViewController new];
//    vc.pageVM = [_sourceDone objectAtIndex:indexPath.row];
//    DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
//    [nav pushViewController:vc animated:YES ];
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (_segmentedControl.selectedSegmentIndex == 0) {
        return CGSizeMake(SCREEN_WIDTH, 150);
    } else {
        DDPageVM* vm =[_sourceContent objectAtIndex:indexPath.row];
        CGFloat width;
        CGFloat height;
        width = SCREEN_WIDTH/2 - 20;
        height = vm.imageHeight/vm.imageWidth * width + 110;
        height = MAX(height, 50);
        height = MIN(height, SCREEN_HEIGHT/1.5);
        return CGSizeMake(width, height);
    }
}

@end
