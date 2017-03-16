//
//  SNRItem.h
//  sonarr-ios
//
//  Created by Harry Singh on 27/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@class SNRQuality;

@interface SNRItem : JSONModel
@property (strong, nonatomic) SNRQuality *quality;
@property (nonatomic) BOOL allowed;
@end
