//
//  SNRActivityIndicatorView.h
//  sonarr-ios
//
//  Created by Harry Singh on 23/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNRActivityIndicatorView : UIView
+(instancetype __nullable)show:(BOOL)show onView:(id __nonnull)view;
+(instancetype __nullable)showOnTint:(BOOL)show onView:(id __nonnull)view;
@end
