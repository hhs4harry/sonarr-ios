//
//  SNRSeries.m
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRSeries.h"
#import "SNRRatings.h"

@protocol SNRTitle;
@protocol SNRImage;
@protocol SNRGenre;
@protocol SNRQualityProfile;

const NSString * IGNOREEPISODESWITHFILES = @"ignoreEpisodesWithFiles";
const NSString * IGNOREEPISODESWITHOUTFILES = @"ignoreEpisodesWithoutFiles";

@interface SNRSeries()

@property (strong, nonatomic) NSString<Optional> *title;
@property (strong, nonatomic) NSString<Optional> *seriesInfo;
@property (strong, nonatomic) NSString<Optional> *scheduleInfo;
@property (strong, nonatomic) NSArray<SNRTitle, Optional> *alternativeTitles;
@property (strong, nonatomic) NSString<Optional> *sortTitle;
@property (strong, nonatomic) NSNumber<Optional> *seasonCount;
@property (strong, nonatomic) NSNumber<Optional> *totalEpisodeCount;
@property (strong, nonatomic) NSNumber<Optional> *episodeCount;
@property (strong, nonatomic) NSNumber<Optional> *episodeFileCount;
@property (strong, nonatomic) NSNumber<Optional> *sizeOnDisk;
@property (strong, nonatomic) NSString<Optional> *status;
@property (strong, nonatomic) NSString<Optional> *overview;
@property (strong, nonatomic) NSString<Optional> *network;
@property (strong, nonatomic) NSString<Optional> *airTime;
@property (strong, nonatomic) NSArray<Optional, SNRImage> *images;
@property (strong, nonatomic) NSNumber<Optional> *year;
@property (nonatomic) BOOL seasonFolder;
@property (nonatomic) BOOL useSceneNumbering;
@property (strong, nonatomic) NSNumber<Optional> *runtime;
@property (strong, nonatomic) NSNumber *tvdbId;
@property (strong, nonatomic) NSNumber<Optional> *tvRageId;
@property (strong, nonatomic) NSNumber<Optional> *tvMazeId;
@property (strong, nonatomic) NSDate<Optional> *firstAired;
@property (strong, nonatomic) NSDate<Optional> *lastInfoSync;
@property (strong, nonatomic) NSString<Optional> *cleanTitle;
@property (strong, nonatomic) NSString<Optional> *imdbId;
@property (strong, nonatomic) NSString<Optional> *titleSlug;
@property (strong, nonatomic) NSString<Optional> *certification;
@property (strong, nonatomic) NSArray<Optional> *genres;
@property (strong, nonatomic) NSArray<Optional> *tags;
@property (strong, nonatomic) SNRRatings<Optional> *ratings;
@property (strong, nonatomic) NSNumber<Optional> *id;
@property (strong, nonatomic) NSDate<Optional> *nextAiring;
@property (strong, nonatomic) NSDate<Optional> *previousAiring;
@property (strong, nonatomic) NSDate<Optional> *added;
@end

@implementation SNRSeries

+(NSString *)endpoint{
    return @"series";
}

+(NSString *)searchEndpoint{
    return [[self endpoint] stringByAppendingString:@"/lookup"];
}

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    if([propertyName isEqualToString:@"seasonFolder"] ||
       [propertyName isEqualToString:@"monitored"] ||
       [propertyName isEqualToString:@"useSceneNumbering"]){
        return YES;
    }
    return NO;
}

-(NSString *)seriesInfo{
    if(_seriesInfo){
        return _seriesInfo;
    }
    
    if([self.status.lowercaseString isEqualToString:@"ended"]){
        _seriesInfo = [NSString stringWithFormat:@"%@ Seasons (%@)", self.seasonCount.stringValue, self.status.capitalizedString];
        return _seriesInfo;
    }
    _seriesInfo = [self.seasonCount.stringValue stringByAppendingString:@" Seasons"];
    return _seriesInfo;
}

-(NSString *)scheduleInfo{
    if(_scheduleInfo){
        return _scheduleInfo;
    }
    
    if(!self.network){
        _scheduleInfo = @"";
        return _scheduleInfo;
    }
    
    if([self.status.lowercaseString isEqualToString:@"ended"]){
        _scheduleInfo = [@"Aired on " stringByAppendingString:self.network];
        return _scheduleInfo;
    }
    
    if(!self.airTime){
        _scheduleInfo = self.network;
        return _scheduleInfo;
    }
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *timeOnlyFormatter = [[NSDateFormatter alloc] init];
    [timeOnlyFormatter setLocale:locale];
    [timeOnlyFormatter setDateFormat:@"HH:mm"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *today = [NSDate date];
    NSDateComponents *todayComps = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:today];
    
    NSDateComponents *comps = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[timeOnlyFormatter dateFromString:self.airTime]];
    comps.day = todayComps.day;
    comps.month = todayComps.month;
    comps.year = todayComps.year;
    NSDate *date = [calendar dateFromComponents:comps];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.dateStyle = NSDateFormatterNoStyle;
    
    _scheduleInfo = [NSString stringWithFormat:@"%@ on %@", [formatter stringFromDate:date], self.network];
    return _scheduleInfo;
}

-(SNRImage *)imageWithType:(ImageType)type{
    for (SNRImage *image in self.images) {
        if (image.type != type) {
            continue;
        }
        return image;
    }
    
    return nil;
}

#pragma mark - JSON

-(NSDictionary*)toDictionary
{
    NSMutableDictionary *json = [self toDictionaryWithKeys:nil].mutableCopy;
    [json removeObjectForKey:@"added"];
    [json removeObjectForKey:@"nextAiring"];
    [json removeObjectForKey:@"previousAiring"];
    [json removeObjectForKey:@"firstAired"];
    [json removeObjectForKey:@"lastInfoSync"];
    return json;
}

@end
