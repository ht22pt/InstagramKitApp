//
//  ThirdViewController.h
//  InstagramKitApp
//
//  Created by Kamil Waszkiewicz on 20.01.2016.
//  Copyright © 2016 Kamil Waszkiewicz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel/iCarousel.h"
#import "HorizontalPhotosHeaderView.h"
@interface ThirdViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, iCarouselDataSource, iCarouselDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *secondCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)searchTextFieldChanged:(id)sender;

@end
