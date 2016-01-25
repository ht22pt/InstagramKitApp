//
//  FirstViewController.h
//  InstagramKitApp
//
//  Created by Kamil Waszkiewicz on 18.01.2016.
//  Copyright © 2016 Kamil Waszkiewicz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *isLoggedInLabel;
- (IBAction)logOut:(id)sender;

@end

