//
//  SNRSeries.m
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRSeries.h"

@implementation SNRSeries

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    if([propertyName isEqualToString:@"seasonFolder"] ||
       [propertyName isEqualToString:@"monitored"] ||
       [propertyName isEqualToString:@"useSceneNumbering"]){
        return YES;
    }
    return NO;
}
@end
