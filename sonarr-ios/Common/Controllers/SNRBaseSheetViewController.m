//
//  SNRBaseSheetViewController.m
//  sonarr-ios
//
//  Created by Harry Singh on 12/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRBaseSheetViewController.h"
#import <MZFormSheetController/MZFormSheetController.h>
#import <MZFormSheetController/MZFormSheetTransition.h>

@interface SNRBaseSheetViewController ()

@end

@implementation SNRBaseSheetViewController

+(UIViewController *)formViewController{
    MZFormSheetController *formVC = [[MZFormSheetController alloc] initWithViewController:[[self vcStoryboard] instantiateViewControllerWithIdentifier:[self storyboardIdentifier]]];
    formVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    formVC.presentedFormSheetSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.9, CGRectGetHeight([UIScreen mainScreen].bounds) * 0.5);
    return formVC;
}

@end
