//
//  HomeViewController.h
//  InstagramKitApp
//
//  Created by Kamil Waszkiewicz on 18.01.2016.
//  Copyright © 2016 Kamil Waszkiewicz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *isLoggedInLabel;
- (IBAction)optionsClick:(id)sender;
- (IBAction)moreButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@end

