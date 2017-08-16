//
//  UIFont+Sonarr.m
//  Sonarr
//
//  Created by Harry Singh on 13/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFont+Sonarr.h"
#import "SNRConstants.h"

@implementation UIFont (Sonarr)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:kDefaultFontBoldName size:fontSize];
}

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:kDefaultFontName size:fontSize];
}

#pragma clang diagnostic pop

@end
