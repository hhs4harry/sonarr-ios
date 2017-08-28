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

+(UIBarButtonItem *)backButtonTarget:(id)target andSelector:(SEL)selector{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [btn setImage:[UIImage imageNamed:@"chevron_left"] forState:UIControlStateNormal];
    [btn setTitle:@"Back" forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btn.titleLabel setTextColor:[UIColor whiteColor]];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -21, 0, 0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}
@end
