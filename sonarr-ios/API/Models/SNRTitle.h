//
//  SNRTitle.h
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SNRTitle : JSONModel
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *seasonNumber;
@end
