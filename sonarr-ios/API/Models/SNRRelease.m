//
//  SNRRelease.m
//  sonarr-ios
//
//  Created by Harry Singh on 27/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRRelease.h"
#import "SNRConstants.h"

@implementation SNRRelease

+(NSString *)endpoint{
    return @"release";
}

+(NSString *)downloadEndpoint{
    return @"release/push";
}

+(BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"fullSeason"] ||
        [propertyName isEqualToString:@"sceneSource"] ||
        [propertyName isEqualToString:@"approved"] ||
        [propertyName isEqualToString:@"downloadAllowed"] ||
        [propertyName isEqualToString:@"state"]) {
        return YES;
    }
    
    return NO;
}

-(NSString *)formattedSize {
    if (self.size && self.size.floatValue) {
        if (self.size.floatValue / kBytesInMB > kMBInGB) {
            return [NSString stringWithFormat:@"%0.2f GB", (self.size.floatValue / kBytesInMB) / kMBInGB];
        } else {
            return [NSString stringWithFormat:@"%0.2f MB", (self.size.floatValue / kBytesInMB)];
        }
    }
    return @"0b";
}

@end
