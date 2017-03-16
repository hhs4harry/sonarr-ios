//
//  SNRQueue.h
//  sonarr-ios
//
//  Created by Harry Singh on 27/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@class SNRSeries;

@interface SNRQueue : JSONModel
@property (strong, nonatomic) SNRSeries *series;
@end
