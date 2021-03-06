//
//  SNRServer.h
//  sonarr-ios
//
//  Created by Harry Singh on 13/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;
@class SNRServerConfig;
@class SNRStatus;
@class SNRSeries;
@class SNRAPIClient;
@class SNRProfile;
@class SNRRootFolder;
@class SNRServer;
@class SNREpisode;
@class SNREpisodeFile;
@class SNRRelease;

typedef enum : NSInteger {
    SNRServerStatusUnknown = -1,
    SNRServerStatusNotRechable,
    SNRServerStatusActive
}  SNRServerStatus;

@protocol SNRServerProtocol <NSObject>
@optional
-(void)didAddSeries:(NSDictionary<NSNumber *, SNRSeries *> * _Nonnull)series forServer:(SNRServer * _Nonnull)server;
-(void)didRemoveSeries:(NSDictionary<NSNumber *, SNRSeries *> * _Nonnull)series forServer:(SNRServer * _Nonnull)server;
@end

@interface SNRServer : NSObject <NSCopying>
@property (readonly) SNRAPIClient * _Nonnull client;
@property (readonly) SNRServerConfig * _Nonnull config;
@property (readonly) SNRServerStatus serverStatus;

@property (readonly) NSMutableArray<SNRSeries *> * _Nullable series;
@property (readonly) NSArray<SNRProfile *> * _Nullable profiles;
@property (readonly) NSArray<SNRRootFolder *> * _Nullable rootFolders;
@property (assign, nonatomic) id<SNRServerProtocol> _Nullable delegate;
@property (assign, nonatomic) BOOL active;

-(NSString * _Nonnull)generateURLWithEndpoint:(NSString * _Nonnull)endpoint;

-(instancetype _Nullable)initWithConfig:(SNRServerConfig * _Nonnull)config;

-(void)validateServerWithCompletion:(void(^ _Nullable)(SNRStatus * _Nullable status, NSError * _Nullable error))completion;

-(void)profilesWithCompletion:(void(^ _Nullable)(NSArray<SNRProfile *> * _Nullable profiles, NSError * _Nullable error))completion;
-(void)rootFolderswithCompletion:(void(^ _Nullable)(NSArray<SNRRootFolder *> * _Nullable rootFolders, NSError * _Nullable error))completion;

-(void)seriesWithRefresh:(BOOL)refresh withCompletion:(void(^ _Nullable)(NSArray<SNRSeries *> * _Nullable series, NSError * _Nullable error))completion;
-(void)searchForSeries:(NSString * _Nonnull)series withCompletion:(void(^ _Nullable)(NSArray<SNRSeries *> * _Nullable series, NSError * _Nullable error))completion;
-(void)addSeries:(SNRSeries * _Nonnull)series withCompletion:(void(^ _Nullable)(SNRSeries * _Nullable series, NSError * _Nullable error))completion;
-(void)deleteSeries:(SNRSeries * _Nonnull)series withFiles:(BOOL)files withCompletion:(void(^ _Nullable)(BOOL success, NSError * _Nullable error))completion;

-(void)episodesForSeries:(SNRSeries * _Nonnull)series withCompletion:(void(^ _Nullable)(NSArray<SNREpisode *> * _Nullable episodes, NSError * _Nullable error))completion;
-(void)episodeFilesForSeries:(SNRSeries * _Nonnull)series withCompletion:(void(^ _Nullable)(NSArray<SNREpisodeFile *> * _Nullable series, NSError * _Nullable error))completion;
-(void)updateEpisode:(SNREpisode * _Nonnull)episode withCompletion:(void(^ _Nullable)(SNREpisode * _Nullable episode, NSError * _Nullable error))completion;

-(void)releasesForEpisode:(SNREpisode * _Nonnull)episode withCompletion:(void(^ _Nullable)(NSArray<SNRRelease *> * _Nullable releases, NSError * _Nullable error))completion;
-(void)downloadRelease:(SNRRelease * _Nonnull)release onEpisode:(SNREpisode * _Nonnull)episode withCompletion:(void(^ _Nullable)(SNRRelease * _Nullable releases, NSError * _Nullable error))completion;
@end
