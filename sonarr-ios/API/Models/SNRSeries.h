//
//  SNRSeries.h
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "SNRImage.h"

@protocol SNRImage;
@protocol SNRSeason;

extern const NSString * IGNOREEPISODESWITHFILES;
extern const NSString * IGNOREEPISODESWITHOUTFILES;

@interface SNRSeries : JSONModel
+(NSString *)endpoint;
+(NSString *)searchEndpoint;
-(SNRImage *)imageWithType:(ImageType)type;

@property (readonly) NSNumber *id;
@property (readonly) NSNumber *tvdbId;
@property (readonly) NSString<Optional> *title;
@property (readonly) NSString<Optional> *seriesInfo;
@property (readonly) NSString<Optional> *scheduleInfo;
@property (readonly) NSArray<Optional, SNRImage> *images;
@property (readonly) NSString<Optional> *overview;
@property (strong, nonatomic) NSArray<Optional, SNRSeason> *seasons;
@property (strong, nonatomic) NSNumber<Optional> *qualityProfileId;
@property (strong, nonatomic) NSNumber<Optional> *profileId;
@property (strong, nonatomic) NSString<Optional> *seriesType;
@property (strong, nonatomic) NSString<Optional> *path;
@property (nonatomic) BOOL monitored;
@property (strong, nonatomic) NSDictionary<Optional> *addOptions;
@end
