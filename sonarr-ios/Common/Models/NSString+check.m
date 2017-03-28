//
//  NSString+check.m
//  sonarr-ios
//
//  Created by Harry Singh on 27/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "NSString+check.h"

@implementation NSString (check)
-(BOOL)nonEmpty{
    if(!self.length){
        return NO;
    }
    
    if(![[self componentsSeparatedByString:@" "] componentsJoinedByString:@""].length){
        return NO;
    }
    
    return YES;
}

@end
