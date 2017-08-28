//
//  SNRConstants.h
//  Sonarr
//
//  Created by Harry Singh on 9/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kParallaxRatio 0.25
#define kBannerSize CGSizeMake(1920, 1080)
#define kBannerSizeRatio MIN(kBannerSize.width, kBannerSize.height) / MAX(kBannerSize.width, kBannerSize.height)
#define kDefaultFontName @"OpenSans-Light"
#define kDefaultFontBoldName @"OpenSans-Bold"
#define kBytesInMB 1048576
#define kMBInGB 1000
#define kNoSeriesHeight 50.0f;
#define kSeriesHeightPercentage 0.6f;

@interface SNRConstants : NSObject
+(UIBarButtonItem *)backButtonTarget:(id)target andSelector:(SEL)selector;

@end
