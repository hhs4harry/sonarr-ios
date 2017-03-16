//
//  SNREpisode.h
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@class SNRQuality;

@interface SNREpisode : JSONModel
@property (strong, nonatomic) NSNumber *seriesId;
@property (strong, nonatomic) NSNumber<Optional> *episodeFileId;
@property (strong, nonatomic) NSNumber *seasonNumber;
@property (strong, nonatomic) NSNumber<Optional> *episodeNumber;
@property (copy, nonatomic) NSString<Optional> *title;
@property (strong, nonatomic) NSDate<Optional> *airDate;
@property (strong, nonatomic) NSDate<Optional> *airDateUtc;
@property (copy, nonatomic) NSString<Optional> *overView;
@property (nonatomic) BOOL hasFile;
@property (nonatomic) BOOL monitored;
@property (strong, nonatomic) NSNumber<Optional> *sceneEpisodeNumber;
@property (strong, nonatomic) NSNumber<Optional> *sceneSeasonNumber;
@property (strong, nonatomic) NSNumber<Optional> *tvDbEpisodeId;
@property (strong, nonatomic) NSNumber<Optional> *absoluteEpisodeNumber;
@property (nonatomic) BOOL downloading;
@property (strong, nonatomic) NSNumber *id;
@end
