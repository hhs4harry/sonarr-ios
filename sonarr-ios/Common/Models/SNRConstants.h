//
//  SNRConstants.h
//  Sonarr
//
//  Created by Harry Singh on 9/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kParallaxRatio 0.25
#define kBannerSize CGSizeMake(1920, 1080)
#define kBannerSizeRatio MIN(kBannerSize.width, kBannerSize.height) / MAX(kBannerSize.width, kBannerSize.height)
#define kDefaultFontName @"Arial"

@interface SNRConstants : NSObject

@end
