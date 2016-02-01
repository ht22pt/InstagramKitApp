//
//  HorizontalPhotosHeaderView.h
//  InstagramKitApp
//
//  Created by Kamil Waszkiewicz on 01.02.2016.
//  Copyright © 2016 Kamil Waszkiewicz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel/iCarousel.h"

@interface HorizontalPhotosHeaderView : UICollectionReusableView

@property (strong, nonatomic) IBOutlet iCarousel *headerCarousel;

@end
