//
//  SNRRelease.m
//  sonarr-ios
//
//  Created by Harry Singh on 27/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRRelease.h"

@implementation SNRRelease

+(NSString *)endpoint{
    return @"release";
}

+(BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"fullSeason"] ||
        [propertyName isEqualToString:@"sceneSource"] ||
        [propertyName isEqualToString:@"approved"] ||
        [propertyName isEqualToString:@"downloadAllowed"]) {
        return YES;
    }
    
    return NO;
}

@end
