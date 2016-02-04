//
//  FirstViewController.m
//  InstagramKitApp
//
//  Created by Kamil Waszkiewicz on 18.01.2016.
//  Copyright © 2016 Kamil Waszkiewicz. All rights reserved.
//

#import "FirstViewController.h"
#import "DetailViewController.h"
#import <InstagramKit/InstagramKit.h>
#import "CustomCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kNumberOfCellsInARowPortrait 3
#define kNumberOfCellsInARowLandscape 4
#define kFetchItemsCount 9

@interface FirstViewController ()

@property (nonatomic, weak) InstagramEngine *instagramEngine;
@property (nonatomic, strong) InstagramPaginationInfo *currentPaginationInfo;
@property (nonatomic, strong) NSMutableArray *mediaArray;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mediaArray = [[NSMutableArray alloc] init];
    self.instagramEngine = [InstagramEngine sharedEngine];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userAuthenticationChanged:)
                                                 name:InstagramKitUserAuthenticationChangedNotification
                                               object:nil];
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

- (void)requestSelfRecentMediaWithCount
{
    [self.instagramEngine getSelfRecentMediaWithCount:kFetchItemsCount
                                maxId:self.currentPaginationInfo.nextMaxId
                                success:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
                                    self.currentPaginationInfo = paginationInfo;
                                    
                                    [self.mediaArray addObjectsFromArray:media];
                                    [self.collectionView reloadData];
                                    
                                    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.mediaArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];

                                    if(paginationInfo)
                                        self.moreButton.hidden = NO;
                                    else
                                        self.moreButton.hidden = YES;
                                    
                                }
                                failure:^(NSError *error, NSInteger serverStatusCode) {
                                    NSLog(@"Load Self Media With Count Failed");
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailForIndexPath:indexPath];
}

- (void)showDetailForIndexPath:(NSIndexPath *)indexPath
{
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

- (IBAction)optionsClick:(id)sender {
    NSString *other1 = @"";
    if ([self.instagramEngine isSessionValid])
        other1 = @"Sign Out";
    else
        other1 = nil;
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, nil];
    
    [actionSheet showInView:self.view];
}

- (IBAction)moreButtonClick:(id)sender {
    [self requestSelfRecentMediaWithCount];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Sign Out"]) {
        [self.instagramEngine logout];
        self.isLoggedInLabel.text = @"Niezalogowany";
        [self.mediaArray removeAllObjects];
        [self.collectionView reloadData];
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"Cancel pressed --> Cancel ActionSheet");
    }
}

- (void)userAuthenticationChanged:(NSNotification *)notification
{
    self.currentPaginationInfo = nil;
    
    BOOL isSessionValid = [self.instagramEngine isSessionValid];
    
    if(isSessionValid) {
        self.isLoggedInLabel.text = @"";
        [self requestSelfRecentMediaWithCount];
    }
    else {
        self.isLoggedInLabel.text = @"Niezalogowany";
    }
}

@end
