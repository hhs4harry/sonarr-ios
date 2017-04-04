//
//  SNRSeries.h
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol SNRImage;
@protocol SNRSeason;

extern const NSString * IGNOREEPISODESWITHFILES;
extern const NSString * IGNOREEPISODESWITHOUTFILES;

@interface SNRSeries : JSONModel
+(NSString *)endpoint;
+(NSString *)searchEndpoint;

@property (strong, readonly) NSNumber *id;
@property (strong, readonly) NSString<Optional> *title;
@property (strong, readonly) NSString<Optional> *seriesInfo;
@property (strong, readonly) NSString<Optional> *scheduleInfo;
@property (strong, readonly) NSArray<Optional, SNRImage> *images;
@property (strong, nonatomic) NSArray<Optional, SNRSeason> *seasons;
@property (strong, nonatomic) NSNumber<Optional> *qualityProfileId;
@property (strong, nonatomic) NSString<Optional> *seriesType;
@property (strong, nonatomic) NSString<Optional> *path;
@property (nonatomic) BOOL monitored;
@property (strong, nonatomic) NSDictionary<Optional> *addOptions;
@end
