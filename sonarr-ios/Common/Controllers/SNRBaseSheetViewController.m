//
//  SNRBaseSheetViewController.m
//  sonarr-ios
//
//  Created by Harry Singh on 12/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRBaseSheetViewController.h"
#import <MZFormSheetPresentationController/MZFormSheetPresentationViewController.h>

@interface SNRBaseSheetViewController ()

@end

@implementation SNRBaseSheetViewController

+(UIViewController *)formViewController{
    MZFormSheetPresentationViewController *formVC = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:[[self vcStoryboard] instantiateViewControllerWithIdentifier:[self storyboardIdentifier]]];
    formVC.presentationController.contentViewSize = [self contentViewSize];
    formVC.allowDismissByPanningPresentedView = YES;
    formVC.interactivePanGestureDismissalDirection = MZFormSheetPanGestureDismissDirectionAll;
    
    return formVC;
}

+(CGSize)contentViewSize{
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.9, CGRectGetHeight([UIScreen mainScreen].bounds) * 0.4);
}

@end
