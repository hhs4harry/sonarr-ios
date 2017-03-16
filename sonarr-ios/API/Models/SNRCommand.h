//
//  SNRCommand.h
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SNRCommand : JSONModel
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *startedOn;
@property (strong, nonatomic) NSDate *stateChangeTime;
@property (nonatomic) BOOL sentUpdatesToClient;
@property (copy, nonatomic) NSString *state;
@property (strong, nonatomic) NSNumber *id;
@end
