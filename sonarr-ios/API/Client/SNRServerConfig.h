//
//  SNRServerConfig.h
//  sonarr-ios
//
//  Created by Harry Singh on 13/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNRServerConfig : NSObject <NSCopying>
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *hostname;
@property (strong, nonatomic) NSNumber *port;
@property (strong, nonatomic) NSString *apiKey;
@property (nonatomic) BOOL SSL;
@end
