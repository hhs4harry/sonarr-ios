//
//  SNRServer.h
//  sonarr-ios
//
//  Created by Harry Singh on 13/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SNRServerConfig;
@class SNRStatus;

@interface SNRServer : NSObject <NSCoding>

-(instancetype)initWithConfig:(SNRServerConfig *)config;
-(void)validateServerWithCompletion:(void(^)(SNRStatus *status, NSError *error))completion;
@end
