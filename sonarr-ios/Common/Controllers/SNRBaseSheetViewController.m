//
//  SNRBaseSheetViewController.m
//  sonarr-ios
//
//  Created by Harry Singh on 12/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRBaseSheetViewController.h"
#import <MZFormSheetPresentationController/MZFormSheetPresentationViewController.h>

@interface SNRBaseSheetViewController () <MZFormSheetPresentationContentSizing>

@end

@implementation SNRBaseSheetViewController

+(UIViewController *)viewController{
    MZFormSheetPresentationViewController *formVC = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:[[self vcStoryboard] instantiateViewControllerWithIdentifier:[self storyboardIdentifier]]];
    formVC.allowDismissByPanningPresentedView = YES;
    formVC.interactivePanGestureDismissalDirection = MZFormSheetPanGestureDismissDirectionAll;

    return formVC;
}

- (BOOL)shouldUseContentViewFrameForPresentationController:(MZFormSheetPresentationController *)presentationController {
    return YES;
}

- (CGRect)contentViewFrameForPresentationController:(MZFormSheetPresentationController *)presentationController currentFrame:(CGRect)currentFrame {
    CGFloat viewW = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat viewH = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    if(viewW > viewH){
        return CGRectMake(viewW * 0.2, viewH * 0.2, viewW * 0.6, viewH * 0.6);
    }
    
    return CGRectMake(viewW * 0.05, viewH * 0.3, viewW * 0.9, viewH * 0.4);
}

@end
