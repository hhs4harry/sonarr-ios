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
+(NSString *)endpoint;

@property (copy, nonatomic) NSString<Optional> *guid;
@property (strong, nonatomic) SNRQuality<Optional> *quality;
@property (strong, nonatomic) NSNumber<Optional> *age;
@property (strong, nonatomic) NSNumber<Optional> *size;
@property (copy, nonatomic) NSString<Optional> *indexer;
@property (copy, nonatomic) NSString<Optional> *releaseGroup;
@property (copy, nonatomic) NSString<Optional> *title;
@property (nonatomic) BOOL fullSeason;
@property (nonatomic) BOOL sceneSource;
@property (strong, nonatomic) NSNumber<Optional> *seasonNumber;
@property (copy, nonatomic) NSString<Optional> *language;
@property (copy, nonatomic) NSString<Optional> *seriesTitle;
@property (copy, nonatomic) NSArray<Optional> *episodeNumbers;
@property (nonatomic) BOOL approved;
@property (strong, nonatomic) NSNumber<Optional> *tvRageId;
@property (copy, nonatomic) NSArray<Optional> *rejections;
@property (strong, nonatomic) NSDate<Optional> *publishDate;
@property (copy, nonatomic) NSString<Optional> *downloadUrl;
@property (nonatomic) BOOL downloadAllowed;

-(NSString *)formattedSize;
@end
