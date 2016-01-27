//
//  SelectedUserDetails.m
//  InstagramKitApp
//
//  Created by Kamil Waszkiewicz on 27.01.2016.
//  Copyright © 2016 Kamil Waszkiewicz. All rights reserved.
//

#import "SelectedUserDetails.h"
#import "DetailViewController.h"

@interface SelectedUserDetails ()

@property (nonatomic, weak) InstagramEngine *instagramEngine;
@property (nonatomic, strong) InstagramPaginationInfo *currentPaginationInfo;
@property (nonatomic, strong) NSMutableArray *mediaArray;

@end

@implementation SelectedUserDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mediaArray = [[NSMutableArray alloc] init];
    self.instagramEngine = [InstagramEngine sharedEngine];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestMediaForUserId];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"selectedUserImage"];
        [self.navigationController popViewControllerAnimated:NO];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestMediaForUserId
{
    [self.instagramEngine getMediaForUser:self.media.user.Id
                              withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
                                  [self.mediaArray removeAllObjects];
                                  [self.mediaArray addObjectsFromArray:media];
                                  [self.collectionView reloadData];
                              }
                                  failure:^(NSError *error, NSInteger statusCode) {
                                      NSLog(@"Load Media For User Id Failed");
                                      NSLog(@"%@",[error localizedDescription]);
                                  }];
    
}

#pragma mark - UICollectionViewDataSource Methods -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mediaArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserCell" forIndexPath:indexPath];
    InstagramMedia *media = self.mediaArray[indexPath.row];
    [cell setImageUrl:media.thumbnailURL];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailForIndexPath:indexPath];
}

- (void)showDetailForIndexPath:(NSIndexPath *)indexPath {
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    DetailViewController* detailController = (DetailViewController*)navController.topViewController;
    InstagramMedia *media = self.mediaArray[indexPath.row];
    detailController.media = media;
    [self presentViewController:navController animated:YES completion:nil];
}

@end
