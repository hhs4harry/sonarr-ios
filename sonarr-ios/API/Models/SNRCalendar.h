//
//  SNRCalendar.h
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@class SNREpisodeFile;
@class SNRSeries;

@interface SNRCalendar : JSONModel
@property (strong, nonatomic) NSNumber<Optional> *id;
@property (strong, nonatomic) NSNumber *seriesId;
@property (strong, nonatomic) NSNumber *episodeFileId;
@property (strong, nonatomic) NSNumber *seasonNumber;
@property (strong, nonatomic) NSNumber *episodeNumber;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSDate *airDate;
@property (strong, nonatomic) NSDate *airDateUtc;
@property (copy, nonatomic) NSString *overview;
@property (strong, nonatomic) SNREpisodeFile *episodeFile;
@property (nonatomic) BOOL hasFile;
@property (nonatomic) BOOL monitored;
@property (strong, nonatomic) NSNumber *absoluteEpisodeNumber;
@property (nonatomic) BOOL unverifiedSceneNumbering;
@property (strong, nonatomic) SNRSeries *series;
@end
