//
//  SNRServerConfig.h
//  sonarr-ios
//
//  Created by Harry Singh on 13/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNRServerConfig : NSObject <NSCopying>
@property (readonly, nonatomic) NSString *hostname;
@property (readonly, nonatomic) NSNumber *port;
@property (readonly, nonatomic) NSString *apiKey;
@property (readonly, nonatomic) BOOL SSL;
-(instancetype)initWithHostname:(NSString *)hostname apiKey:(NSString *)apiKey port:(NSNumber *)port andSSL:(BOOL)ssl;
@end
