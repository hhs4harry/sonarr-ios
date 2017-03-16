//
//  SNRRecord.m
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRRecord.h"

@implementation SNRRecord

+(BOOL)propertyIsIgnored:(NSString *)propertyName{
    if([propertyName isEqualToString:@"unverifiedSceneNumbering"]){
        return YES;
    }
    return NO;
}

@end
