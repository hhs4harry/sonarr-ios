//
//  SNRConstants.m
//  Sonarr
//
//  Created by Harry Singh on 9/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRConstants.h"
#import <UIKit/UIKit.h>

@implementation SNRConstants

+(UIBarButtonItem *)backButton{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100 , 25)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chevron_left"]];
    
    [view addSubview:imageView];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-10] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeHeight multiplier:0.9 constant:1.0] setActive:YES];

    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    title.font = [UIFont systemFontOfSize:13];
    title.text = @"Back";
    title.textColor = [UIColor whiteColor];
    
    [view addSubview:title];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    
    [[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:2] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0] setActive:YES];
    
    [view layoutIfNeeded];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    return item;
}

@end
