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
    
    self.currentPaginationInfo = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userAuthenticationChanged:)
                                                 name:InstagramKitUserAuthenticationChangedNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    BOOL isSessionValid = [self.instagramEngine isSessionValid];
    if(isSessionValid) {
        self.isLoggedInLabel.text = @"";
    }
    else {
        self.isLoggedInLabel.text = @"Niezalogowany";
    }
    
    NSLog(isSessionValid ? @"Yes" : @"No");
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
    [self.instagramEngine getSelfRecentMediaWithCount:9
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
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int numberOfCellInRow = 3;
    CGFloat cellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow - 20;
    return CGSizeMake(cellWidth, cellWidth);
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
    BOOL isSessionValid = [self.instagramEngine isSessionValid];
    if(isSessionValid) {
        [self requestSelfRecentMediaWithCount];
    }
}

@end
