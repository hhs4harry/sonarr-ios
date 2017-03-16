//
//  SNRQuality.m
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRQuality.h"

@implementation SNRQuality
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    if([propertyName isEqualToString:@"proper"]){
        return YES;
    }
    return NO;
}
@end
