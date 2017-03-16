//
//  SNRQuality.h
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@class SNRRevision;

@interface SNRQuality : JSONModel
@property (strong, nonatomic) NSNumber<Optional> *id;
@property (copy, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) SNRQuality<Optional> *quality;
@property (strong, nonatomic) SNRRevision<Optional> *revision;
@property (nonatomic) BOOL proper;
@end
