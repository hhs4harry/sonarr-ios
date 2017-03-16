//
//  SNRCutoff.h
//  sonarr-ios
//
//  Created by Harry Singh on 27/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SNRCutoff : JSONModel
@property (strong, nonatomic) NSNumber *id;
@property (copy, nonatomic) NSString *name;
@end
