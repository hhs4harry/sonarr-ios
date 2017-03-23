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
+(NSString *)endpoint;

@property (strong, readonly) NSNumber *id;
@property (strong, readonly) NSString<Optional> *title;
@property (strong, readonly) NSString<Optional> *seriesInfo;
@property (strong, readonly) NSString<Optional> *scheduleInfo;
@property (strong, readonly) NSArray<Optional, SNRImage> *images;
@end
