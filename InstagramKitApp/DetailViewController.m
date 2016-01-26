//
//  DetailViewController.m
//  InstagramKitApp
//
//  Created by Kamil Waszkiewicz on 25.01.2016.
//  Copyright © 2016 Kamil Waszkiewicz. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    if(self.media.standardResolutionImageURL)
        [self.imageView sd_setImageWithURL:self.media.standardResolutionImageURL];
    else
        [self.imageView sd_setImageWithURL:self.media.thumbnailURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backNavigationItem:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
