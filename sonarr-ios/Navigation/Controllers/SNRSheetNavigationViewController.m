//
//  SNRSheetNavigationViewController.m
//  sonarr-ios
//
//  Created by Harry Singh on 30/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRSheetNavigationViewController.h"
#import <MZFormSheetPresentationController/MZFormSheetPresentationContentSizing.h>
#import "SNRBaseSheetViewController.h"
@interface SNRSheetNavigationViewController () <MZFormSheetPresentationContentSizing, UINavigationControllerDelegate>
@property (nonatomic, strong) MZFormSheetContentSizingNavigationControllerAnimator *animator;

@end

@implementation SNRSheetNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animator = [[MZFormSheetContentSizingNavigationControllerAnimator alloc] init];
    self.delegate = self;
}

- (BOOL)shouldUseContentViewFrameForPresentationController:(MZFormSheetPresentationController *)presentationController {
    if([self.visibleViewController conformsToProtocol:@protocol(MZFormSheetPresentationContentSizing)] &&
       [self.visibleViewController respondsToSelector:@selector(shouldUseContentViewFrameForPresentationController:)]){
        [(id<MZFormSheetPresentationContentSizing>)self.visibleViewController shouldUseContentViewFrameForPresentationController:presentationController];
    }
    
    return YES;
}

- (CGRect)contentViewFrameForPresentationController:(MZFormSheetPresentationController *)presentationController currentFrame:(CGRect)currentFrame {
    if([self.visibleViewController conformsToProtocol:@protocol(MZFormSheetPresentationContentSizing)] &&
       [self.visibleViewController respondsToSelector:@selector(contentViewFrameForPresentationController:currentFrame:)]){
        CGRect returnedReect = [(id<MZFormSheetPresentationContentSizing>)self.visibleViewController contentViewFrameForPresentationController:presentationController currentFrame:currentFrame];
        return returnedReect;
    }
    
    CGFloat viewW = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat viewH = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    if(viewW > viewH){
        return CGRectMake(viewW * 0.2, viewH * 0.2, viewW * 0.6, viewH * 0.6);
    }
    
    return CGRectMake(viewW * 0.05, viewH * 0.3, viewW * 0.9, viewH * 0.4);
}

#pragma mark - <UINavigationControllerDelegate>

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    self.animator.operation = operation;
    return self.animator;
}

@end
