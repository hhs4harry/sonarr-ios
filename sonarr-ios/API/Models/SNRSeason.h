//
//  SNRSeason.h
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@class SNRStatistics;
@class SNREpisode;

@interface SNRSeason : JSONModel
@property (copy, nonatomic) NSNumber *seasonNumber;
@property (nonatomic) BOOL monitored;
@property (strong, nonatomic) SNRStatistics<Optional> *statistics;
@property (strong, nonatomic) NSArray<SNREpisode *><Optional> *episodes;
@end
