//
//  SNREpisodeFile.m
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNREpisodeFile.h"
#import "SNRConstants.h"

@implementation SNREpisodeFile

+(NSString *)endpoint{
    return @"episodefile";
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
