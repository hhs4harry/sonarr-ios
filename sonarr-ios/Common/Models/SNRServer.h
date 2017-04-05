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
@class SNRSeries;
@class UIImage;
@class SNRAPIClient;
@class SNRProfile;
@class SNRRootFolder;

@protocol SNRServerProtocol <NSObject>
@optional
-(void)didAddSeries:(SNRSeries * __nonnull)series atIndex:(NSInteger)index;
-(void)didRemoveSeries:(SNRSeries * __nonnull)series atIndex:(NSInteger)index;
@end

@interface SNRServer : NSObject <NSCopying>
@property (readonly) SNRAPIClient * __nonnull client;
@property (readonly) SNRServerConfig * __nonnull config;
@property (assign, nonatomic) BOOL active;

@property (readonly) NSArray<SNRSeries *> * __nullable series;
@property (readonly) NSArray<SNRProfile *> * __nullable profiles;
@property (readonly) NSArray<SNRRootFolder *> * __nullable rootFolders;
@property (assign, nonatomic) id<SNRServerProtocol> __nullable delegate;

-(NSString * __nonnull)generateURLWithEndpoint:(NSString * __nonnull)endpoint;

-(instancetype __nullable)initWithConfig:(SNRServerConfig * __nonnull)config NS_DESIGNATED_INITIALIZER;
-(void)validateServerWithCompletion:(void(^ __nullable)(SNRStatus * __nullable status, NSError * __nullable error))completion;
-(void)profilesWithCompletion:(void(^ __nullable)(NSArray<SNRProfile *> * __nullable profiles, NSError * __nullable error))completion;
-(void)rootFolderswithCompletion:(void(^ __nullable)(NSArray<SNRRootFolder *> * __nullable rootFolders, NSError * __nullable error))completion;
-(void)seriesWithRefresh:(BOOL)refresh andCompletion:(void(^ __nullable)(NSArray<SNRSeries *> * __nullable series, NSError * __nullable error))completion;
-(void)searchForSeries:(NSString * __nonnull)series withCompletion:(void(^ __nullable)(NSArray<SNRSeries *> * __nullable series, NSError * __nullable error))completion;
-(void)addSeries:(SNRSeries * __nonnull)series withCompletion:(void(^ __nullable)(SNRSeries * __nullable series, NSError * __nullable error))completion;
@end
