//
//  SNRRatings.h
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SNRRatings : JSONModel
@property (strong, nonatomic) NSNumber *votes;
@property (strong, nonatomic) NSNumber *value;
@end
