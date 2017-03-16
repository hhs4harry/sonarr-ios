//
//  SNREpisodeFile.h
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@class SNRQuality;

@interface SNREpisodeFile : JSONModel
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSNumber *seriesId;
@property (strong, nonatomic) NSNumber *seasonNumber;
@property (copy, nonatomic) NSString *relativePath;
@property (copy, nonatomic) NSString *path;
@property (strong, nonatomic) NSNumber *size;
@property (strong, nonatomic) NSDate<Optional> *dateAdded;
@property (strong, nonatomic) SNRQuality<Optional> *quality;

@end
