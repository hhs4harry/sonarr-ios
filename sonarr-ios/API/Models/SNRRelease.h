//
//  SNRRelease.h
//  sonarr-ios
//
//  Created by Harry Singh on 27/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@class SNRQuality;

typedef enum : NSUInteger {
    Default = 0,
    Downloading = 1,
    Downloaded = 2,
} DownloadState;

@interface SNRRelease : JSONModel
+(NSString *)endpoint;
+(NSString *)downloadEndpoint;

@property (copy, nonatomic) NSString *guid;
@property (strong, nonatomic) SNRQuality<Optional> *quality;
@property (strong, nonatomic) NSNumber<Optional> *age;
@property (strong, nonatomic) NSNumber<Optional> *size;
@property (copy, nonatomic) NSString<Optional> *indexer;
@property (copy, nonatomic) NSString<Optional> *releaseGroup;
@property (copy, nonatomic) NSString<Optional> *title;
@property (copy, nonatomic) NSString<Optional> *protocol;
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
@property (assign, nonatomic) DownloadState state;
-(NSString *)formattedSize;
@end
