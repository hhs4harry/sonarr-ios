//
//  SNREpisode.m
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNREpisode.h"
#import "SNREpisodeFile.h"
#import "SNRQuality.h"

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

-(NSString *)formattedAirDate {
    if (!self.airDateUtc) {
        return @"";
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd, YYYY"];
    NSString *dateString = [dateFormat stringFromDate:self.airDateUtc];
    return dateString;
}

-(NSString *)episodeFileStatus {
    if (!self.hasFile) {
        return @"Missing";
    } else if (self.hasFile && !self.file) {
        return @"Loading...";
    } else if (self.file.quality.quality.name) {
        return self.file.quality.quality.name;
    } else if (self.airDateUtc && [[NSDate date] laterDate:self.airDateUtc] == self.airDateUtc) {
        return @"Unaired";
    } else {
        return @"Unknown";
    }
}

-(NSString *)seasonxEpisode{
    if (!self.seasonNumber || !self.episodeNumber) {
        return @"";
    }
    
    return [[self.seasonNumber.stringValue stringByAppendingString:@"x"] stringByAppendingString:self.episodeNumber.stringValue];
}
@end
