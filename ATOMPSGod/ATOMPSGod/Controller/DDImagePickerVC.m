//
//  DDImagePickerVC.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/8/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "DDImagePickerVC.h"

@interface DDImagePickerVC ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *selectedPhotoCountLabel;

@end

@implementation DDImagePickerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedPhotoCountLabel.backgroundColor = [UIColor yellowColor];
    _selectedPhotoCountLabel.layer.cornerRadius = _selectedPhotoCountLabel.frame.size.width/2;
    _selectedPhotoCountLabel.clipsToBounds = YES;
    
    UINib *nib = [UINib nibWithNibName:@"DDPhotoCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"DDPhotoCell"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
