//
//  SearchViewController.m
//  InstagramKitApp
//
//  Created by Kamil Waszkiewicz on 20.01.2016.
//  Copyright © 2016 Kamil Waszkiewicz. All rights reserved.
//

#import "SearchViewController.h"
#import <InstagramKit/InstagramKit.h>
#import "CustomCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DetailViewController.h"

#define kNumberOfCellsInARowPortrait 3
#define kNumberOfCellsInARowLandscape 4

@interface SearchViewController ()

@property (nonatomic, weak) InstagramEngine *instagramEngine;
@property (nonatomic, strong) InstagramPaginationInfo *currentPaginationInfo;
@property (nonatomic, strong) NSMutableArray *mediaArray;
@property (nonatomic, strong) NSString *searchTextFieldContent;
@property (nonatomic, strong) NSString *instagramUserId;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) HorizontalPhotosHeaderView *headerView;

@end

@implementation SearchViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mediaArray = [[NSMutableArray alloc] init];
    self.instagramEngine = [InstagramEngine sharedEngine];
    self.secondCollectionView.delegate = self;
    self.secondCollectionView.dataSource = self;
    self.searchTextField.delegate = self;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //free up memory by releasing subviews
    self.headerView.headerCarousel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    self.timer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollCarousel) userInfo:nil repeats:YES];
    
    //configure carousel
    self.headerView.headerCarousel.delegate = self;
    self.headerView.headerCarousel.dataSource = self;
    self.headerView.headerCarousel.type = iCarouselTypeLinear;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.timer invalidate];
}

- (void)requestMediaWithTagName
{
     [self.instagramEngine getMediaWithTagName:self.searchTextFieldContent
                        withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
                            [self.mediaArray removeAllObjects];
                            [self.mediaArray addObjectsFromArray:media];
                            [self.secondCollectionView reloadData];
                            [self.headerView.headerCarousel reloadData];
                        }
                        failure:^(NSError *error, NSInteger statusCode) {
                            NSLog(@"Load Media With Tag Name Failed");
                            NSLog(@"%@",[error localizedDescription]);
                        }];
}

- (void)requestMediaForUserId
{
    [self.instagramEngine getMediaForUser:self.instagramUserId
                                  withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
                                      [self.mediaArray removeAllObjects];
                                      [self.mediaArray addObjectsFromArray:media];
                                      [self.secondCollectionView reloadData];
                                      [self.headerView.headerCarousel reloadData];
                                  }
                                      failure:^(NSError *error, NSInteger statusCode) {
                                          NSLog(@"Load Media For User Id Failed");
                                          NSLog(@"%@",[error localizedDescription]);
                                      }];
    
}

- (void)requestUserDetailsAndMediaForUser
{
    [self.instagramEngine searchUsersWithString:self.searchTextFieldContent
                                    withSuccess:^(NSArray<InstagramUser *> *users, InstagramPaginationInfo *paginationInfo) {
                                        self.instagramUserId = [self getUserIdByUsername:self.searchTextFieldContent usersArray:users];
                                        [self requestMediaForUserId];
                                        NSLog(@"break");
                                    }
                                    failure:^(NSError *error, NSInteger serverStatusCode) {
                                        NSLog(@"Load User Details Failed");
                                        NSLog(@"%@",[error localizedDescription]);
                                    }];
    
}

- (NSString *)getUserIdByUsername:(NSString *)username usersArray:(NSArray<InstagramUser *> *)array
{
    NSString *userId = @"";
    
    for (InstagramUser *user in array) {
        if([user.username isEqualToString:username])
            userId = user.Id;
    }
    return userId;
}

#pragma mark - UICollectionViewDataSource Methods -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mediaArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SecondCell" forIndexPath:indexPath];
    InstagramMedia *media = self.mediaArray[indexPath.row];
    [cell setImageUrl:media.thumbnailURL];
    
    return cell;
}

- (IBAction)searchTextFieldChanged:(id)sender {
    self.searchTextFieldContent = self.searchTextField.text;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        [self requestMediaWithTagName];
    }
    else if(self.segmentedControl.selectedSegmentIndex == 1) {
        [self requestUserDetailsAndMediaForUser];
    }
    
    return [self.searchTextField resignFirstResponder];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
//    return [self.items count];
    return self.mediaArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *carouselImageView = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIView alloc] initWithFrame:self.headerView.headerCarousel.bounds];
        
        carouselImageView = [[UIImageView alloc] initWithFrame:view.bounds];
        carouselImageView.tag = 1;
        carouselImageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:carouselImageView];
    }
    else
    {
        //get a reference to the label in the recycled view
        carouselImageView = (UIImageView *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    InstagramMedia *media = self.mediaArray[index];
    [carouselImageView sd_setImageWithURL:media.thumbnailURL];
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return YES;
        }
        default:
        {
            return value;
        }
    }
}

- (void)scrollCarousel {
    NSInteger newIndex=self.headerView.headerCarousel.currentItemIndex+1;
    if (newIndex > self.headerView.headerCarousel.numberOfItems) {
        newIndex=0;
    }
    
    [self.headerView.headerCarousel scrollToItemAtIndex:newIndex duration:1];
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableview = self.headerView;
    }

    return reusableview;
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
    UICollectionViewFlowLayout *flowLayout = (id)self.secondCollectionView.collectionViewLayout;
    
    if (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)) {
        CGFloat cellWidth = floor((CGRectGetWidth(self.secondCollectionView.bounds)-5) / kNumberOfCellsInARowLandscape);
        flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    } else {
        CGFloat cellWidth = floor((CGRectGetWidth(self.secondCollectionView.bounds)-5) / kNumberOfCellsInARowPortrait);
        flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    }
    
    [flowLayout invalidateLayout]; //force the elements to get laid out again with the new size
}


@end
