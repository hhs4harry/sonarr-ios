//
//  SNREpisode.m
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNREpisode.h"

@implementation SNREpisode

+(NSString *)endpoint{
    return @"episode";
}

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    if([propertyName isEqualToString:@"downloading"]){
        return YES;
    }
    return NO;
}

@end
