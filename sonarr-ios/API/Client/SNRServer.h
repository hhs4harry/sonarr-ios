//
//  SNRServer.h
//  sonarr-ios
//
//  Created by Harry Singh on 13/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SNRServerConfig;

@interface SNRServer : NSObject

-(instancetype)initWithConfig:(SNRServerConfig *)config;

@end
