//
//  SNRSheetNavigationViewController.h
//  sonarr-ios
//
//  Created by Harry Singh on 30/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MZFormSheetPresentationController/MZFormSheetContentSizingNavigationControllerAnimator.h>

@interface SNRSheetNavigationViewController : UINavigationController
@property (nonatomic, strong, readonly) MZFormSheetContentSizingNavigationControllerAnimator *animator;

@end
