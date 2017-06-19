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
#import "SNREpisode.h"
#import "SNRImage.h"
#import "SNRSeason.h"

NSString * const SNR_SERVER_CONFIG  = @"snr_server_config";
NSString * const SNR_SERVER_ACTIVE  = @"snr_server_active";
static NSString * BASEURL;

@interface SNRServer() <NSCoding>
@property (assign, nonatomic) SNRServerStatus serverStatus;
@property (strong, nonatomic) NSMutableArray *observers;
@property (strong, nonatomic) SNRAPIClient *client;
@property (strong, nonatomic) SNRServerConfig *config;
@property (strong, nonatomic) NSMutableArray<SNRSeries *> *series;
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
        
        self.serverStatus = SNRServerStatusUnknown;
        __weak typeof(self) wself = self;
        self.client.networkStatusBlock = ^(NetworkStatus status){
            wself.serverStatus = status ? SNRServerStatusActive : SNRServerStatusNotRechable;
        };
        
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

#pragma mark - Adding / Deleting Series

-(void)addSeries:(NSArray<SNRSeries *> *)series{
    __block NSMutableDictionary *addedSeries = [[NSMutableDictionary alloc] init];
    __block NSMutableArray *toAdd = [[NSMutableArray alloc] init];
    __weak typeof(self) wself = self;
    
    [series enumerateObjectsUsingBlock:^(SNRSeries * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([wself.series containsObject:obj]){
            return;
        }
        
        [toAdd addObject:obj];
        [wself.series addObject:obj];
    }];
    
    [self.series sortUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"sortTitle" ascending:YES]]];
    
    [toAdd enumerateObjectsUsingBlock:^(SNRSeries * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [addedSeries setObject:obj forKey:@(idx)];
    }];
    
    [self fireDidAddSeries:addedSeries];
}

-(void)deleteSeries:(NSArray<SNRSeries *> *)series{
    __block NSMutableDictionary *objToRemove = [[NSMutableDictionary alloc] init];
    __block NSMutableArray *seriesAfterDelete = self.series.mutableCopy ? : [[NSMutableArray alloc] init];
    
    [series enumerateObjectsUsingBlock:^(SNRSeries * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![seriesAfterDelete containsObject:obj]){
            return;
        }
        
        [objToRemove setObject:obj forKey:@([seriesAfterDelete indexOfObject:obj])];
        [seriesAfterDelete removeObject:obj];
    }];
    
    self.series = seriesAfterDelete;

    [self fireDidRemoveSeries:objToRemove];
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
        [profiles sortUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES]]];
        
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
        [rFolders sortUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES]]];
        
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
    if(self.series.count && !refresh){
        return completion(self.series, nil);
    }
    
    __weak typeof(self) wself = self;
    [self.client performGETCallToEndpoint:[self generateURLWithEndpoint:[SNRSeries endpoint]] withParameters:nil andSuccess:^(id responseObject) {
        NSError *error;
        NSMutableArray *series = [SNRSeries arrayOfModelsFromDictionaries:responseObject error:&error];
        
        [wself addSeries:series];
        
        if(completion){
            completion(wself.series, error);
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
        [series sortUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"sortTitle" ascending:YES]]];
        
        completion(series, error);
    } andFailure:^(NSError *error) {
        completion(nil, error);
    }];
}

-(void)addSeries:(SNRSeries *)series withCompletion:(void(^)(SNRSeries * series, NSError * error))completion{
    NSMutableDictionary *params = [series toDictionary].mutableCopy;
    [params setObject:@1 forKey:@"seasonFolder"];
    
    __block SNRSeries *bSeries = series;
    __weak typeof(self) wself = self;
    
    [self.client performPOSTCallToEndpoint:[self generateURLWithEndpoint:[SNRSeries endpoint]] withParameters:params withSuccess:^(id responseObject) {
        NSError *error;
        SNRSeries *addedSeries = [[SNRSeries alloc] initWithDictionary:responseObject error:&error];
        for (SNRImage *image in addedSeries.images) {
            image.image = [bSeries imageWithType:image.type].image;
        }
        
        [wself addSeries:@[addedSeries]];
        
        if(completion){
            completion(addedSeries, error);
        }
    } andFailure:^(NSError *error) {
        if(completion){
            completion(nil, error);
        }
    }];
}

-(void)deleteSeries:(SNRSeries *)series withFiles:(BOOL)files andCompletion:(void(^)(BOOL success, NSError * error))completion{
    NSString *endpoint = [self generateURLWithEndpoint:[NSString stringWithFormat:@"%@/%@", [SNRSeries endpoint], series.id.stringValue]];
    
    __block SNRSeries *bSeries = series;
    __weak typeof(self) wself = self;
    
    [self.client performDELETECallToEndpoint:endpoint withParameters:@{@"deleteFiles" : files ? @"true" : @"false"} andSuccess:^(id responseObject) {
        if(completion){
            completion(YES, nil);
        }

        [wself deleteSeries:@[bSeries]];
    } andFailure:^(NSError *error) {
        if(completion){
            completion(NO, error);
        }
    }];
}

-(void)episodesForSeries:(SNRSeries *)series withCompletion:(void(^)(NSArray<SNREpisode *> *episodes, NSError * error))completion{
    NSString *endpoint = [self generateURLWithEndpoint:[SNREpisode endpoint]];
    
    [self.client performGETCallToEndpoint:endpoint withParameters:@{@"seriesId" : series.id.stringValue} andSuccess:^(id  _Nullable responseObject) {
        NSError *error;
        NSArray<SNREpisode *>* episodes = [SNREpisode arrayOfModelsFromDictionaries:responseObject error:&error];
        
        NSMutableDictionary<NSString *, NSMutableArray<SNREpisode *> *> *seasonEpisode = [[NSMutableDictionary alloc] init];
        
        for (SNREpisode *episode in episodes) {
            NSMutableArray *eps;
            if ([seasonEpisode objectForKey:episode.seasonNumber.stringValue]) {
                eps = [seasonEpisode objectForKey:episode.seasonNumber.stringValue];
            } else {
                eps = [[NSMutableArray alloc] init];
            }
            
            [eps addObject:episode];
            
            [seasonEpisode setObject:eps forKey:episode.seasonNumber.stringValue];
        }
        
        for (SNRSeason *season in series.seasons) {
            season.episodes = seasonEpisode[season.seasonNumber.stringValue];
        }
        
        if(completion){
            completion(episodes, error);
        }
    } andFailure:^(NSError * _Nullable error) {
        if(completion){
            completion(nil, error);
        }
    }];
}

#pragma mark - Delegate

-(void)fireDidAddSeries:(NSDictionary<NSNumber *, SNRSeries *> *)series{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didAddSeries:forServer:)]){
        [self.delegate didAddSeries:series forServer:self];
    }
}

-(void)fireDidRemoveSeries:(NSDictionary<NSNumber *, SNRSeries *> *)series{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didRemoveSeries:forServer:)]){
        [self.delegate didRemoveSeries:series forServer:self];
    }
}

#pragma mark - Getters / Setters

-(NSMutableArray<SNRSeries *> *)series{
    if(!_series){
        _series = [[NSMutableArray alloc] init];
    }
    
    return _series;
}

@end
