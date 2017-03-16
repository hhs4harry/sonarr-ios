//
//  SNRRecord.h
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@class SNRQuality;
@class SNREpisode;
@class SNRSeries;
@class SNRData;

@interface SNRRecord : JSONModel
@property (strong, nonatomic) SNRData<Optional> *data;
@property (strong, nonatomic) NSDate *date; //not parsed for some reason
@property (copy, nonatomic) NSString<Optional> *downloadId;
@property (strong, nonatomic) SNREpisode *episode;
@property (strong, nonatomic) NSNumber *episodeId;
@property (copy, nonatomic) NSString *eventType;
@property (strong, nonatomic) SNRQuality *quality;
@property (nonatomic) BOOL qualityCutoffNotMet;
@property (nonatomic) BOOL unverifiedSceneNumbering;
@property (strong, nonatomic) SNRSeries *series;
@property (strong, nonatomic) NSNumber *seriesId;
@property (copy, nonatomic) NSString *sourceTitle;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *id;
@end
