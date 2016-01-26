//
//  DetailViewController.h
//  InstagramKitApp
//
//  Created by Kamil Waszkiewicz on 25.01.2016.
//  Copyright © 2016 Kamil Waszkiewicz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <InstagramKit/InstagramKit.h>

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) InstagramMedia *media;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
- (IBAction)backNavigationItem:(id)sender;

@end
