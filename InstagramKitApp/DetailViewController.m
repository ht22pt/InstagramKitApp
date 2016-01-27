//
//  DetailViewController.m
//  InstagramKitApp
//
//  Created by Kamil Waszkiewicz on 25.01.2016.
//  Copyright © 2016 Kamil Waszkiewicz. All rights reserved.
//

#import "DetailViewController.h"
#import "SelectedUserDetails.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.showUserImagesButton setTitle:self.media.user.username forState:UIControlStateNormal];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SelectedUserDetails *selectedUserController = segue.destinationViewController;
    selectedUserController.media = self.media;
}

@end
