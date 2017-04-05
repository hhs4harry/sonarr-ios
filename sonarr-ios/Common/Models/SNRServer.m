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
#import "SNRProfile.h"
#import "SNRRootFolder.h"

NSString * const SNR_SERVER_CONFIG  = @"snr_server_config";
NSString * const SNR_SERVER_ACTIVE  = @"snr_server_active";
static NSString * BASEURL;

@interface SNRServer() <NSCoding>
@property (strong, nonatomic) NSMutableArray *observers;
@property (strong, nonatomic) SNRAPIClient *client;
@property (strong, nonatomic) SNRServerConfig *config;
@property (strong, nonatomic) NSArray<SNRSeries *> *series;
@property (strong, nonatomic) NSArray<SNRProfile *> *profiles;
@property (strong, nonatomic) NSArray<SNRRootFolder *> *rootFolders;
@end

@implementation SNRServer

#pragma mark - Life cycle

-(instancetype)initWithConfig:(SNRServerConfig *)config{
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
        self.client = [[SNRAPIClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@:%@", config.SSL ? @"https" : @"http", config.hostname, config.port.stringValue]]];
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
        copy.series = _series.copy;
        copy.profiles = _profiles.copy;
        copy.rootFolders = _rootFolders.copy;
    }
    return copy;
}

#pragma mark - API

-(NSString *)generateURLWithEndpoint:(NSString *)endpoint{
    endpoint = [endpoint stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet whitespaceCharacterSet] invertedSet]];
    
    NSArray *components = [endpoint componentsSeparatedByString:@"?"];
    endpoint = components.firstObject;
    NSString *url = [NSString stringWithFormat:@"/api/%@?apikey=%@",
            endpoint,
            self.config.apiKey];
    
    for (NSString *comp in components) {
        if([comp isEqualToString:endpoint]){
            continue;
        }
        [[url stringByAppendingString:@"&"] stringByAppendingString:@"comp"];
    }
    
    return url;
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
        
        [self profilesWithCompletion:nil];
        [self rootFolderswithCompletion:nil];
        
        completion(status, error);
    } andFailure:^(NSError *error) {
        completion(nil, error);
    }];
}

-(void)profilesWithCompletion:(void(^)(NSArray<SNRProfile *> *profiles, NSError *error))completion{
    if(self.profiles){
        if(completion){
            completion(self.profiles, nil);
        }
        return;
    }
    
    [self.client performGETCallToEndpoint:[self generateURLWithEndpoint:[SNRProfile endpoint]] withParameters:nil andSuccess:^(id responseObject) {
        NSError *error;
        NSMutableArray *profiles = [SNRProfile arrayOfModelsFromDictionaries:responseObject error:&error];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
        [profiles sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        self.profiles = profiles;
        
        if(completion){
            completion(self.profiles, error);
        }
    } andFailure:^(NSError *error) {
        if(completion){
            completion(nil, error);
        }
    }];
}

-(void)rootFolderswithCompletion:(void(^)(NSArray<SNRRootFolder *> *rootFolders, NSError * error))completion{
    if(self.rootFolders){
        if(completion){
            completion(self.rootFolders, nil);
        }
        return;
    }
    
    [self.client performGETCallToEndpoint:[self generateURLWithEndpoint:[SNRRootFolder endpoint]] withParameters:nil andSuccess:^(id responseObject) {
        NSError *error;
        NSMutableArray *rFolders = [SNRRootFolder arrayOfModelsFromDictionaries:responseObject error:&error];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
        [rFolders sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        self.rootFolders = rFolders;
        
        if(completion){
            completion(self.rootFolders, error);
        }
    } andFailure:^(NSError *error) {
        if(completion){
            completion(nil, error);
        }
    }];
}

-(void)seriesWithRefresh:(BOOL)refresh andCompletion:(void(^)(NSArray<SNRSeries *> *series, NSError *error))completion{
    if(self.series && !refresh){
        return completion(self.series, nil);
    }
    
    [self.client performGETCallToEndpoint:[self generateURLWithEndpoint:[SNRSeries endpoint]] withParameters:nil andSuccess:^(id responseObject) {
        NSError *error;
        NSMutableArray *series = [SNRSeries arrayOfModelsFromDictionaries:responseObject error:&error];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortTitle" ascending:YES];
        [series sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        self.series = series;
        
        if(completion){
            completion(self.series, error);
        }
    } andFailure:^(NSError *error) {
        if(completion){
            completion(nil, error);
        }
    }];
}

-(void)searchForSeries:(NSString *)series withCompletion:(void(^)(NSArray<SNRSeries *> *series, NSError *error))completion{
    NSString *endpoint = [self generateURLWithEndpoint:[SNRSeries searchEndpoint]];
    endpoint = [NSString stringWithFormat:@"%@&term=%@", endpoint, [series stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet whitespaceCharacterSet] invertedSet]]];
    
    [self.client performGETCallToEndpoint:endpoint withParameters:nil andSuccess:^(id responseObject) {
        NSError *error;
        NSMutableArray *series = [SNRSeries arrayOfModelsFromDictionaries:responseObject error:&error];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortTitle" ascending:YES];
        [series sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        completion(series, error);
    } andFailure:^(NSError *error) {
        completion(nil, error);
    }];
}

-(void)addSeries:(SNRSeries * __nonnull)series withCompletion:(void(^ __nullable)(SNRSeries * __nullable series, NSError * __nullable error))completion{
    [self.client performPOSTCallToEndpoint:[self generateURLWithEndpoint:[SNRSeries endpoint]] withParameters:[series toDictionary] withSuccess:^(id responseObject) {
        NSError *error;
        SNRSeries *addedSeries = [[SNRSeries alloc] initWithDictionary:responseObject error:&error];
        if(completion){
            completion(addedSeries, error);
        }
    } andFailure:^(NSError *error) {
        if(completion){
            completion(nil, error);
        }
    }];
}

#pragma mark - Delegate

-(void)fireDidAddSeries:(SNRSeries *)series{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didAddSeries:atIndex:)]){
        [self.delegate didAddSeries:series atIndex:[self.series indexOfObject:series]];
    }
}

-(void)fireDidRemoveSeries:(SNRSeries *)series{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didRemoveSeries:atIndex:)]){
        [self.delegate didRemoveSeries:series atIndex:[self.series indexOfObject:series]];
    }
}

@end
