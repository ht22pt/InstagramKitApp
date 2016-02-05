//
//  SecondViewController.m
//  InstagramKitApp
//
//  Created by Kamil Waszkiewicz on 18.01.2016.
//  Copyright © 2016 Kamil Waszkiewicz. All rights reserved.
//

#import "SecondViewController.h"
#import <InstagramKit/InstagramKit.h>
#import "SVProgressHUD.h"


@interface SecondViewController ()

@end

@implementation SecondViewController
{
    InstagramEngine *instagramEngine;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    instagramEngine = [InstagramEngine sharedEngine];
    InstagramKitLoginScope loginScope = InstagramKitLoginScopePublicContent;
    NSURL *authURL = [instagramEngine authorizationURLForScope:loginScope];
    
    if([instagramEngine.accessToken length] == 0) {
        [SVProgressHUD showWithStatus:@"Loading..."];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.webView loadRequest:[NSURLRequest requestWithURL:authURL]];
        });
    }
    
    self.webView.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated {
    
    BOOL isSessionValid = [instagramEngine isSessionValid];
    
    if(isSessionValid) {
        self.isLoggedInLabel.text = @"Zalogowany";
    }
    else {
        self.isLoggedInLabel.text = @"";
        InstagramKitLoginScope loginScope = InstagramKitLoginScopePublicContent;
        NSURL *authURL = [instagramEngine authorizationURLForScope:loginScope];
        [SVProgressHUD showWithStatus:@"Loading..."];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.webView loadRequest:[NSURLRequest requestWithURL:authURL]];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSError *error;
    if ([instagramEngine receivedValidAccessTokenFromURL:request.URL error:&error]) {
//        [webView removeFromSuperview];
        webView.hidden = YES;
        [SVProgressHUD dismiss];
        self.isLoggedInLabel.text = @"Zalogowany";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Zalogowałeś się." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    if(![instagramEngine isSessionValid])
        webView.hidden = NO;
}



@end
