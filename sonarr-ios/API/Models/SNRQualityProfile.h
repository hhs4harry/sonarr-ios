//
//  SNRQualityProfile.h
//  sonarr-ios
//
//  Created by Harry Singh on 27/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol SNRValue;

@interface SNRQualityProfile : JSONModel
@property (copy, nonatomic) NSArray<SNRValue> *value;
@end
