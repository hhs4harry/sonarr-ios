//
//  SNRSheetNavigationViewController.h
//  sonarr-ios
//
//  Created by Harry Singh on 30/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNRNavigationViewController.h"
@class MZFormSheetContentSizingNavigationControllerAnimator;

@interface SNRSheetNavigationViewController : SNRNavigationViewController
@property (nonatomic, strong, readonly) MZFormSheetContentSizingNavigationControllerAnimator *animator;

@end
