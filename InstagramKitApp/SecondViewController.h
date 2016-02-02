//
//  SecondViewController.h
//  InstagramKitApp
//
//  Created by Kamil Waszkiewicz on 18.01.2016.
//  Copyright © 2016 Kamil Waszkiewicz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *isLoggedInLabel;

@end

