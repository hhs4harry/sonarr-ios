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
    MZFormSheetPresentationViewController *formVC = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:[[SNRBaseViewController vcStoryboard] instantiateViewControllerWithIdentifier:[self storyboardIdentifier]]];
    formVC.presentationController.contentViewSize = [SNRBaseSheetViewController contentViewSize];
    formVC.allowDismissByPanningPresentedView = YES;
    formVC.interactivePanGestureDismissalDirection = MZFormSheetPanGestureDismissDirectionAll;
    
    return formVC;
}

+(CGSize)contentViewSize{
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.9, 250);
}

@end
