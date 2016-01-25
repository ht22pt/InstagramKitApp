//
//  FirstViewController.m
//  InstagramKitApp
//
//  Created by Kamil Waszkiewicz on 18.01.2016.
//  Copyright © 2016 Kamil Waszkiewicz. All rights reserved.
//

#import "FirstViewController.h"
#import <InstagramKit/InstagramKit.h>
#import "CustomCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FirstViewController ()

@property (nonatomic, weak) InstagramEngine *instagramEngine;
@property (nonatomic, strong) InstagramPaginationInfo *currentPaginationInfo;
@property (nonatomic, strong) NSMutableArray *mediaArray;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mediaArray = [[NSMutableArray alloc] init];
    self.instagramEngine = [InstagramEngine sharedEngine];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    BOOL isSessionValid = [self.instagramEngine isSessionValid];
    if(isSessionValid) {
        self.isLoggedInLabel.text = @"";
    }
    else {
        self.isLoggedInLabel.text = @"Niezalogowany";
    }
    
    NSLog(isSessionValid ? @"Yes" : @"No");
    [self requestSelfRecentMedia];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestSelfRecentMedia
{
    [self.instagramEngine getSelfRecentMediaWithSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        [self.mediaArray removeAllObjects];
        [self.mediaArray addObjectsFromArray:media];
        [self.collectionView reloadData];
     } failure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"Load Self Media Failed");
       }];
}


#pragma mark - UICollectionViewDataSource Methods -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mediaArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell" forIndexPath:indexPath];
    InstagramMedia *media = self.mediaArray[indexPath.row];
    [cell setImageUrl:media.thumbnailURL];

    return cell;
}

- (IBAction)logOut:(id)sender {
    [self.instagramEngine logout];
    self.isLoggedInLabel.text = @"Niezalogowany";
    [self.mediaArray removeAllObjects];
    [self.collectionView reloadData];
}
@end
