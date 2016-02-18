//
//  CustomCell.m
//  InstagramKitApp
//
//  Created by Kamil Waszkiewicz on 18.01.2016.
//  Copyright © 2016 Kamil Waszkiewicz. All rights reserved.
//

#import "CustomCell.h"
#import "UIImageView+AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CustomCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CustomCell

- (void)setImageUrl:(NSURL *)imageURL
{
    [self.imageView sd_setImageWithURL:imageURL
                    placeholderImage:[UIImage imageNamed:@"first"]];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.imageView setImage:nil];
}

@end
