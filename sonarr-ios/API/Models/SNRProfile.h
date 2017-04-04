//
//  SNRProfile.h
//  sonarr-ios
//
//  Created by Harry Singh on 27/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@class SNRCutoff;
@protocol SNRItem;

@interface SNRProfile : JSONModel
+(NSString *)endpoint;

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) SNRCutoff *cutoff;
@property (copy, nonatomic) NSArray<SNRItem> *items;
@property (strong, nonatomic) NSNumber *id;
@end
