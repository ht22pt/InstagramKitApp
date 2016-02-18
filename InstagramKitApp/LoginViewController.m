//
//  LoginViewController.m
//  InstagramKitApp
//
//  Created by Kamil Waszkiewicz on 18.01.2016.
//  Copyright © 2016 Kamil Waszkiewicz. All rights reserved.
//

#import "LoginViewController.h"
#import <InstagramKit/InstagramKit.h>


@interface LoginViewController ()

@end

@implementation LoginViewController
{
    InstagramEngine *instagramEngine;
    UIActivityIndicatorView *indicator;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    instagramEngine = [InstagramEngine sharedEngine];
    InstagramKitLoginScope loginScope = InstagramKitLoginScopePublicContent;
    NSURL *authURL = [instagramEngine authorizationURLForScope:loginScope];
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.transform = CGAffineTransformMakeScale(2.50, 2.50);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userAuthenticationChanged:)
                                                 name:InstagramKitUserAuthenticationChangedNotification
                                               object:nil];
    
    if([instagramEngine.accessToken length] == 0) {
        [indicator startAnimating];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.webView loadRequest:[NSURLRequest requestWithURL:authURL]];
        });
    }
    
    self.webView.delegate = self;
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSError *error;
    if ([instagramEngine receivedValidAccessTokenFromURL:request.URL error:&error]) {
        webView.hidden = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Zalogowałeś się." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [indicator stopAnimating];
    if(![instagramEngine isSessionValid])
        webView.hidden = NO;
}


- (void)userAuthenticationChanged:(NSNotification *)notification
{
    InstagramKitLoginScope loginScope = InstagramKitLoginScopePublicContent;
    NSURL *authURL = [instagramEngine authorizationURLForScope:loginScope];
    BOOL isSessionValid = [instagramEngine isSessionValid];
    
    if(isSessionValid) {
        self.isLoggedInLabel.text = @"Zalogowany";
        [indicator stopAnimating];
    }
    else {
        self.isLoggedInLabel.text = @"";
        [indicator startAnimating];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.webView loadRequest:[NSURLRequest requestWithURL:authURL]];
        });
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
