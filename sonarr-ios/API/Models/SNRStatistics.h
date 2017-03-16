//
//  SNRStatistics.h
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SNRStatistics : JSONModel
@property (strong, nonatomic) NSDate<Optional> *previousAiring;
@property (strong, nonatomic) NSNumber *episodeFileCount;
@property (strong, nonatomic) NSNumber *episodeCount;
@property (strong, nonatomic) NSNumber *totalEpisodeCount;
@property (strong, nonatomic) NSNumber *sizeOnDisk;
@property (strong, nonatomic) NSNumber *percentOfEpisodes;

@end
