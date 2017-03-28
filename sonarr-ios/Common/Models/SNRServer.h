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

@interface SNRServer : NSObject <NSCopying>
@property (strong, nonatomic) NSArray<SNRSeries *> *series;
@property (strong, readonly) SNRServerConfig *config;
@property (readonly, nonatomic) SNRAPIClient *client;
@property (assign, nonatomic) BOOL active;

-(NSString *)generateURLWithEndpoint:(NSString *)endpoint;

-(instancetype)initWithConfig:(SNRServerConfig *)config;
-(void)validateServerWithCompletion:(void(^)(SNRStatus *status, NSError *error))completion;
-(void)seriesWithRefresh:(BOOL)refresh andCompletion:(void(^)(NSArray<SNRSeries *> *series, NSError *error))completion;
-(void)searchForSeries:(NSString *)series withCompletion:(void(^)(NSArray<SNRSeries *> *series, NSError *error))completion;
@end
