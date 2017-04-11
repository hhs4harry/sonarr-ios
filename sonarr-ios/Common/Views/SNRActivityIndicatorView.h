//
//  SNRActivityIndicatorView.h
//  sonarr-ios
//
//  Created by Harry Singh on 23/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNRActivityIndicatorView : UIView
+(instancetype _Nullable)show:(BOOL)show onView:(id _Nonnull)view;
+(instancetype _Nullable)showOnTint:(BOOL)show onView:(id _Nonnull)view;
@end
