//
//  SelectedUserDetails.h
//  InstagramKitApp
//
//  Created by Kamil Waszkiewicz on 27.01.2016.
//  Copyright © 2016 Kamil Waszkiewicz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <InstagramKit/InstagramKit.h>
#import "CustomCell.h"

@interface SelectedUserDetails : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) InstagramMedia *media;

@end
