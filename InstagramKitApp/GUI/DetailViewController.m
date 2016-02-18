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
    self.likeCount.text = [@(self.media.likesCount) stringValue];
    self.commentCount.text = [@(self.media.commentCount) stringValue];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"selectedUserImage"]) {
        [self.showUserImagesButton setHidden:NO];
        [self.showUserImagesButton setTitle:self.media.user.username forState:UIControlStateNormal];
    }
    else
        [self.showUserImagesButton setHidden:YES];
    
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

- (IBAction)saveImageButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download" message:@"Are you sure you want to save this image?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SelectedUserDetails *selectedUserController = segue.destinationViewController;
    selectedUserController.media = self.media;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"selectedUserImage"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        //do nothing
    }
    else if(buttonIndex ==1) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //id completionTarget, SEL completionSelector and void *contextInfo if you want to be notified when the UIImage is done saving
            UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil, nil);
        });

    }
}

@end
