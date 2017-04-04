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

@interface SNRServer : NSObject <NSCopying>
@property (readonly) SNRAPIClient * __nonnull client;
@property (readonly) SNRServerConfig * __nonnull config;
@property (assign, nonatomic) BOOL active;

@property (readonly) NSArray<SNRSeries *> * __nullable series;
@property (readonly) NSArray<SNRProfile *> * __nullable profiles;
@property (readonly) NSArray<SNRRootFolder *> * __nullable rootFolder;

-(NSString * __nonnull)generateURLWithEndpoint:(NSString * __nonnull)endpoint;

-(instancetype __nullable)initWithConfig:(SNRServerConfig * __nonnull)config;
-(void)validateServerWithCompletion:(void(^ __nullable)(SNRStatus * __nullable status, NSError * __nullable error))completion;
-(void)profilesWithCompletion:(void(^ __nullable)(NSArray<SNRProfile *> * __nullable profiles, NSError * __nullable error))completion;
-(void)rootFolderwithCompletion:(void(^ __nullable)(NSArray<SNRRootFolder *> * __nullable rootFolder, NSError * __nullable error))completion;
-(void)seriesWithRefresh:(BOOL)refresh andCompletion:(void(^ __nullable)(NSArray<SNRSeries *> * __nullable series, NSError * __nullable error))completion;
-(void)searchForSeries:(NSString * __nonnull)series withCompletion:(void(^ __nullable)(NSArray<SNRSeries *> * __nullable series, NSError * __nullable error))completion;
@end
