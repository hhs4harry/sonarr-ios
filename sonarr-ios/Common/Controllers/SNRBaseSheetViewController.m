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

#pragma mark - Presenting / Dismissing

-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    if(![viewControllerToPresent isMemberOfClass:[MZFormSheetController class]]){
        return [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
    
    [self mz_presentFormSheetController:(id)viewControllerToPresent animated:flag completionHandler:^(MZFormSheetController * _Nonnull formSheetController) {
        if(completion){
            completion();
        }
    }];
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    [self mz_dismissFormSheetControllerAnimated:flag completionHandler:^(MZFormSheetController * _Nonnull formSheetController) {
        if(completion){
            completion();
        }
    }];
}

@end
