//
//  SNRServer.m
//  sonarr-ios
//
//  Created by Harry Singh on 13/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRServer.h"
#import "SNRServerConfig.h"
#import "SNRAPIClient.h"
#import "SNRStatus.h"

static NSString * BASEURL;

@interface SNRServer()
@property (strong, nonatomic) SNRAPIClient *client;
@property (strong, nonatomic) SNRServerConfig *config;
@end

@implementation SNRServer

-(instancetype)initWithConfig:(SNRServerConfig *)config{
    config.username = @"eksplex";
    config.password = @"";
    config.hostname = @"eksplex.asuscomm.com";
    config.port = @8990;
    config.apiKey = @"ef96fe34c1294c66b93d42519d61f43e";
    config.SSL = YES;
    
    if(!config ||
       !config.apiKey ||
       !config.hostname){
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.client = [SNRAPIClient client];
        self.config = config;
        [self getStatus];
    }
    return self;
}

-(NSString *)generateURLWith:(NSString *)endpoint{
    return [NSString stringWithFormat:@"%@://%@:%@/api/%@?apikey=%@", self.config.SSL ? @"https" : @"http", self.config.hostname, self.config.port.stringValue, endpoint, self.config.apiKey];
}

-(void)getStatus{
    [self.client setTaskDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
        return NSURLSessionAuthChallengeUseCredential;
    }];
    
    [self.client setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        return NSURLSessionResponseAllow;
    }];
//    self.client.securityPolicy.SSLPinningMode = AFSSLPinningModeNone;

    [self.client performGETCallToEndpoint:[self generateURLWith:[SNRStatus endpoint]]
                           withParameters:nil
                               andSuccess:^(id responseObject) {
                                   NSLog(@"Response");
    }                          andFailure:^(NSError *error) {
        NSLog(@"Error");
    }];
}

-(instancetype)init{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"- init is not a valid initializer. Use initWithConfig"
                                 userInfo:nil];
}

@end
