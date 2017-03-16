//
//  SNRRelease.h
//  sonarr-ios
//
//  Created by Harry Singh on 27/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@class SNRQuality;

@interface SNRRelease : JSONModel
@property (copy, nonatomic) NSString *guid;
@property (strong, nonatomic) SNRQuality *quality;
@property (strong, nonatomic) NSNumber *age;
@property (strong, nonatomic) NSNumber *size;
@property (copy, nonatomic) NSString *indexer;
@property (copy, nonatomic) NSString *releaseGroup;
@property (copy, nonatomic) NSString *title;
@property (nonatomic) BOOL fullSeason;
@property (nonatomic) BOOL sceneSource;
@property (strong, nonatomic) NSNumber *seasonNumber;
@property (copy, nonatomic) NSString *language;
@property (copy, nonatomic) NSString *seriesTitle;
@property (copy, nonatomic) NSArray *episodeNumbers;
@property (nonatomic) BOOL approved;
@property (strong, nonatomic) NSNumber *tvRageId;
@property (copy, nonatomic) NSArray *rejections;
@property (strong, nonatomic) NSDate *publishDate;
@property (copy, nonatomic) NSString *downloadUrl;
@property (nonatomic) BOOL downloadAllowed;
@end
