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
#import "SNRSeries.h"

NSString * const SNR_SERVER_CONFIG  = @"snr_server_config";
NSString * const SNR_SERVER_ACTIVE  = @"snr_server_active";
static NSString * BASEURL;

@interface SNRServer() <NSCoding>
@property (strong, nonatomic) SNRAPIClient *client;
@property (strong, nonatomic) SNRServerConfig *config;
@property (strong, nonatomic) NSMutableArray *observers;
@end

@implementation SNRServer

#pragma mark - Life cycle

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
        if(!config.port){
            config.port = @8989;
        }
        self.client = [SNRAPIClient client];
        self.config = config;
    }
    return self;
}

-(instancetype)init{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"- init is not a valid initializer. Use initWithConfig"
                                 userInfo:nil];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(!aDecoder){
        return nil;
    }
    
    SNRServer *server = [self initWithConfig:[aDecoder decodeObjectForKey:SNR_SERVER_CONFIG]];
    server.active = [aDecoder decodeBoolForKey:SNR_SERVER_ACTIVE];
    return server;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    if(!aCoder){
        return;
    }
    
    [aCoder encodeObject:_config forKey:SNR_SERVER_CONFIG];
    [aCoder encodeBool:_active forKey:SNR_SERVER_ACTIVE];
}

- (id)copyWithZone:(nullable NSZone *)zone{
    SNRServer *copy = [[[self class] allocWithZone:zone] init];
    if(copy){
        copy.client = [_client copy];
        copy.config = [_config copy];
        copy.active = _active;
    }
    return copy;
}

#pragma mark - API

-(NSString *)generateURLWithEndpoint:(NSString *)endpoint{
    return [NSString stringWithFormat:@"%@://%@:%@/api/%@?apikey=%@",
            self.config.SSL ? @"https" : @"http",
            self.config.hostname,
            self.config.port.stringValue,
            endpoint,
            self.config.apiKey];
}

-(void)validateServerWithCompletion:(void(^)(SNRStatus *status, NSError *error))completion{
    [self.client performGETCallToEndpoint:[self generateURLWithEndpoint:[SNRStatus endpoint]] withParameters:nil andSuccess:^(id responseObject) {
        NSError *error;
        SNRStatus *status;
        if(!(status = [[SNRStatus alloc] initWithDictionary:responseObject error:&error])){
            NSLog(@"Error at SNRClient - ValidateServerWithCompletion");
            NSLog(@"Error parsing to JSON model: %@", error.userInfo);
            NSLog(@"Response: %@", responseObject);
        }
        completion(status, error);
    } andFailure:^(NSError *error) {
        completion(nil, error);
    }];
}

-(void)seriesWithRefresh:(BOOL)refresh andCompletion:(void(^)(NSArray<SNRSeries *> *series, NSError *error))completion{
    if(self.series && !refresh){
        return completion(self.series, nil);
    }
    
    [self.client performGETCallToEndpoint:[self generateURLWithEndpoint:[SNRSeries endpoint]] withParameters:nil andSuccess:^(id responseObject) {
        NSError *error;
        self.series = [SNRSeries arrayOfModelsFromDictionaries:responseObject error:&error];
        
        if(completion){
            completion(self.series, error);
        }
    } andFailure:^(NSError *error) {
        if(completion){
            completion(nil, error);
        }
    }];
}


//#pragma mark - Image URL
//
//-(NSURL *)generateImageURLWithEndpoint:(NSString *)endpoint{
//    return [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@:%@/api/%@",
//                                 self.config.SSL ? @"https" : @"http",
//                                 self.config.hostname,
//                                 self.config.port.stringValue,
//                                 endpoint]];
//}
@end
