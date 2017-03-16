//
//  SNRSeries.h
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol SNRTitle;
@protocol SNRImage;
@protocol SNRSeason;
@protocol SNRGenre;
@protocol SNRQualityProfile;
@class SNRRatings;

@interface SNRSeries : JSONModel
@property (copy, nonatomic) NSString<Optional> *title;
@property (copy, nonatomic) NSArray<SNRTitle, Optional> *alternativeTitles;
@property (copy, nonatomic) NSString<Optional> *sortTitle;
@property (strong, nonatomic) NSNumber<Optional> *seasonCount;
@property (strong, nonatomic) NSNumber<Optional> *totalEpisodeCount;
@property (strong, nonatomic) NSNumber<Optional> *episodeCount;
@property (strong, nonatomic) NSNumber<Optional> *episodeFileCount;
@property (strong, nonatomic) NSNumber<Optional> *sizeOnDisk;
@property (copy, nonatomic) NSString<Optional> *status;
@property (copy, nonatomic) NSString<Optional> *overview;
@property (strong, nonatomic) NSDate<Optional> *nextAiring;
@property (strong, nonatomic) NSDate<Optional> *previousAiring;
@property (copy, nonatomic) NSString<Optional> *network;
@property (copy, nonatomic) NSString<Optional> *airTime;
@property (copy, nonatomic) NSArray<Optional, SNRImage> *images;
@property (copy, nonatomic) NSArray<Optional, SNRSeason> *seasons;
@property (strong, nonatomic) NSNumber<Optional> *year;
@property (copy, nonatomic) NSString<Optional> *path;
@property (strong, nonatomic) NSNumber<Optional> *profileId;
@property (nonatomic) BOOL seasonFolder;
@property (nonatomic) BOOL monitored;
@property (nonatomic) BOOL useSceneNumbering;
@property (strong, nonatomic) NSNumber<Optional> *runtime;
@property (strong, nonatomic) NSNumber<Optional> *tvdbId;
@property (strong, nonatomic) NSNumber<Optional> *tvRageId;
@property (strong, nonatomic) NSNumber<Optional> *tvMazeId;
@property (strong, nonatomic) NSDate<Optional> *firstAired;
@property (strong, nonatomic) NSDate<Optional> *lastInfoSync;
@property (copy, nonatomic) NSString<Optional> *seriesType;
@property (copy, nonatomic) NSString<Optional> *cleanTitle;
@property (copy, nonatomic) NSString<Optional> *imdbId;
@property (copy, nonatomic) NSString<Optional> *titleSlug;
@property (copy, nonatomic) NSString<Optional> *certification;
@property (copy, nonatomic) NSArray<Optional> *genres;
@property (copy, nonatomic) NSArray<Optional> *tags;
@property (copy, nonatomic) NSDate<Optional> *added;
@property (copy, nonatomic) SNRRatings<Optional> *ratings;
@property (strong, nonatomic) NSNumber<Optional> *qualityProfileId;
@property (copy, nonatomic) NSArray<SNRQualityProfile, Optional> *qualityProfile;
@property (strong, nonatomic) NSNumber *id;
@end
