//
//  SNRServerConfig.m
//  sonarr-ios
//
//  Created by Harry Singh on 13/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRServerConfig.h"

NSString * const SERVER_CONFIG_USERNAME  = @"snr_config_username";
NSString * const SERVER_CONFIG_PASSWORD  = @"snr_conig_password";
NSString * const SERVER_CONFIG_HOSTNAME  = @"snr_config_hostname";
NSString * const SERVER_CONFIG_PORT      = @"snr_config_port";
NSString * const SERVER_CONFIG_APIKEY    = @"snr_config_apikey";
NSString * const SERVER_CONFIG_SSL       = @"snr_config_ssl";

@interface SNRServerConfig() <NSCopying, NSCoding>

@end

@implementation SNRServerConfig

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(!aDecoder){
        return nil;
    }
    
    self = [super init];
    if(self){
        _username = [aDecoder decodeObjectForKey:SERVER_CONFIG_USERNAME];;
        _password = [aDecoder decodeObjectForKey:SERVER_CONFIG_PASSWORD];
        _hostname = [aDecoder decodeObjectForKey:SERVER_CONFIG_HOSTNAME];
        _port     = [aDecoder decodeObjectForKey:SERVER_CONFIG_PORT];
        _apiKey   = [aDecoder decodeObjectForKey:SERVER_CONFIG_APIKEY];
        _SSL      = [aDecoder decodeBoolForKey:SERVER_CONFIG_SSL];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    if(!aCoder){
        return;
    }
    
    [aCoder encodeObject:_username forKey:SERVER_CONFIG_USERNAME];
    [aCoder encodeObject:_password forKey:SERVER_CONFIG_PASSWORD];
    [aCoder encodeObject:_hostname forKey:SERVER_CONFIG_HOSTNAME];
    [aCoder encodeObject:_port forKey:SERVER_CONFIG_PORT];
    [aCoder encodeObject:_apiKey forKey:SERVER_CONFIG_APIKEY];
    [aCoder encodeBool:_SSL forKey:SERVER_CONFIG_SSL];
}

- (id)copyWithZone:(nullable NSZone *)zone{
    SNRServerConfig *copy = [[[self class] allocWithZone:zone] init];
    if(copy){
        copy.username = [_username copy];
        copy.password = [_password copy];
        copy.hostname = [_hostname copy];
        copy.port = @(_port.integerValue);
        copy.apiKey = [_apiKey copy];
        copy.SSL = _SSL;
    }
    return copy;
}

@end
