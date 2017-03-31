//
//  MZFormSheetPresentationController+Keyboard.m
//  sonarr-ios
//
//  Created by Harry Singh on 30/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "MZFormSheetPresentationController+Keyboard.h"
#import <MZFormSheetPresentationViewController.h>
#import <objc/runtime.h>

@interface MZFormSheetPresentationController()
@property (nonatomic, strong) NSValue *screenFrameWhenKeyboardVisible;
- (CGSize)internalContentViewSize;
- (CGFloat)yCoordinateBelowStatusBar;
- (CGFloat)topInset;
- (CGRect)formSheetViewControllerFrame;
@end

extern const CGFloat MZFormSheetPresentationControllerDefaultAboveKeyboardMargin;

@implementation MZFormSheetPresentationController (Keyboard)

+(void)load{
    Method originalMethod = class_getInstanceMethod(self, @selector(formSheetViewControllerFrame));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(snr_formSheetViewControllerFrame));
    
    BOOL didAddMethod = class_addMethod(self,
                                        @selector(formSheetViewControllerFrame),
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if(didAddMethod){
        class_replaceMethod(self,
                            @selector(snr_formSheetViewControllerFrame),
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - Frame Configuration

- (CGRect)snr_formSheetViewControllerFrame {
    MZFormSheetPresentationViewController *presentationViewController = (MZFormSheetPresentationViewController *)self.presentedViewController;
    
    CGRect formSheetRect = self.presentedView.frame;
    CGSize contentViewSize = self.internalContentViewSize;
    UIView *contentView = presentationViewController.contentViewController.view;
    
    if (CGSizeEqualToSize(contentViewSize, UILayoutFittingCompressedSize)) {
        formSheetRect.size = [contentView systemLayoutSizeFittingSize: contentViewSize];
    } else if (CGSizeEqualToSize(contentViewSize, UILayoutFittingExpandedSize)) {
        formSheetRect.size = [contentView systemLayoutSizeFittingSize: self.containerView.bounds.size];
    } else {
        formSheetRect.size = contentViewSize;
    }
    
    if (self.shouldCenterHorizontally) {
        formSheetRect.origin.x = CGRectGetMidX(self.containerView.bounds) - formSheetRect.size.width/2;
    }
    
    if (self.keyboardVisible && self.movementActionWhenKeyboardAppears != MZFormSheetActionWhenKeyboardAppearsDoNothing) {
        CGRect screenRect = [self.screenFrameWhenKeyboardVisible CGRectValue];
        
        if (screenRect.size.height > CGRectGetHeight(formSheetRect)) {
            switch (self.movementActionWhenKeyboardAppears) {
                case MZFormSheetActionWhenKeyboardAppearsCenterVertically:
                    formSheetRect.origin.y = ([self yCoordinateBelowStatusBar] + screenRect.size.height - formSheetRect.size.height) / 2 - screenRect.origin.y;
                    break;
                case MZFormSheetActionWhenKeyboardAppearsMoveToTop:
                    formSheetRect.origin.y = [self yCoordinateBelowStatusBar];
                    break;
                case MZFormSheetActionWhenKeyboardAppearsMoveToTopInset:
                    formSheetRect.origin.y = [self topInset];
                    break;
                case MZFormSheetActionWhenKeyboardAppearsAlwaysAboveKeyboard:
                case MZFormSheetActionWhenKeyboardAppearsAboveKeyboard:
                    formSheetRect.origin.y = formSheetRect.origin.y + (screenRect.size.height - CGRectGetMaxY(formSheetRect)) - MZFormSheetPresentationControllerDefaultAboveKeyboardMargin;
                default:
                    break;
            }
        } else {
            if (self.movementActionWhenKeyboardAppears == MZFormSheetActionWhenKeyboardAppearsAlwaysAboveKeyboard) {
                formSheetRect.origin.y = formSheetRect.origin.y + (screenRect.size.height - CGRectGetMaxY(formSheetRect)) - MZFormSheetPresentationControllerDefaultAboveKeyboardMargin;
            } else {
                formSheetRect.origin.y = [self yCoordinateBelowStatusBar];
            }
            
        }
        
    } else if (self.shouldCenterVertically) {
        formSheetRect.origin.y = CGRectGetMidY(self.containerView.bounds) - formSheetRect.size.height/2;
    } else {
        formSheetRect.origin.y = self.topInset;
    }
    
    CGRect modifiedPresentedViewFrame = CGRectZero;
    
    if (self.frameConfigurationHandler) {
        modifiedPresentedViewFrame = self.frameConfigurationHandler(self.presentedView,formSheetRect,self.isKeyboardVisible);
    } else {
        modifiedPresentedViewFrame = formSheetRect;
    }

    return modifiedPresentedViewFrame;
}

@end
