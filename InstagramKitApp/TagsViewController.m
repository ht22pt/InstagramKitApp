//
//  TagsViewController.m
//  InstagramKitApp
//
//  Created by Kamil Waszkiewicz on 02.02.2016.
//  Copyright © 2016 Kamil Waszkiewicz. All rights reserved.
//

#import "TagsViewController.h"
#import "DetailViewController.h"
#import <InstagramKit/InstagramKit.h>
#import "CustomCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kNumberOfCellsInARowPortrait 3
#define kNumberOfCellsInARowLandscape 4

@interface TagsViewController ()

@property (nonatomic, weak) InstagramEngine *instagramEngine;
@property (nonatomic, strong) InstagramPaginationInfo *currentPaginationInfo;
@property (nonatomic, strong) NSMutableArray *mediaArray;
@property (nonatomic, strong) NSArray *tagArray;

@end

@implementation TagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tagArray = @[@"bird", @"ball", @"road", @"music"];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.mediaArray = [[NSMutableArray alloc] init];
    self.instagramEngine = [InstagramEngine sharedEngine];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    InstagramMedia *media = self.mediaArray[indexPath.row];
    [cell setImageUrl:media.thumbnailURL];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return self.mediaArray.count;
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

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 0, 20, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    UICollectionViewFlowLayout *flowLayout = (id)self.collectionView.collectionViewLayout;
    
    if (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)) {
        CGFloat cellWidth = floor((CGRectGetWidth(self.collectionView.bounds)-5) / kNumberOfCellsInARowLandscape);
        flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    } else {
        CGFloat cellWidth = floor((CGRectGetWidth(self.collectionView.bounds)-5) / kNumberOfCellsInARowPortrait);
        flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    }
    
    [flowLayout invalidateLayout]; //force the elements to get laid out again with the new size
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TagCell" forIndexPath:indexPath];
    cell.textLabel.text = self.tagArray[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.tagArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tagName = self.tagArray[indexPath.row];
    [self requestMediaWithTagName:tagName];
}

- (void)requestMediaWithTagName:(NSString *)tagName
{
    [self.instagramEngine getMediaWithTagName:tagName
                                  withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
                                      [self.mediaArray removeAllObjects];
                                      [self.mediaArray addObjectsFromArray:media];
                                      [self.collectionView reloadData];
                                  }
                                      failure:^(NSError *error, NSInteger statusCode) {
                                          NSLog(@"Load Media With Tag Name Failed");
                                          NSLog(@"%@",[error localizedDescription]);
                                      }];
}

@end
