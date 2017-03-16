//
//  SNRProfile.h
//  sonarr-ios
//
//  Created by Harry Singh on 27/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@class SNRValue;
@protocol SNRItem;

@interface SNRProfile : JSONModel
@property (strong, nonatomic) SNRValue *value;
@property (copy, nonatomic) NSArray<SNRItem> *items;
@property (strong, nonatomic) NSNumber *id;
@end
