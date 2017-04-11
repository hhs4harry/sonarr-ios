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
-(void)seriesWithRefresh:(BOOL)refresh andCompletion:(void(^ _Nullable)(NSArray<SNRSeries *> * _Nullable series, NSError * _Nullable error))completion;
-(void)searchForSeries:(NSString * _Nonnull)series withCompletion:(void(^ _Nullable)(NSArray<SNRSeries *> * _Nullable series, NSError * _Nullable error))completion;
-(void)addSeries:(SNRSeries * _Nonnull)series withCompletion:(void(^ _Nullable)(SNRSeries * _Nullable series, NSError * _Nullable error))completion;
-(void)deleteSeries:(SNRSeries * _Nonnull)series withFiles:(BOOL)files andCompletion:(void(^ _Nullable)(BOOL success, NSError * _Nullable error))completion;
@end
