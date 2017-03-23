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

@interface SNRServer : NSObject <NSCopying>
@property (assign, nonatomic) BOOL active;
@property (strong, readonly) SNRServerConfig *config;
@property (strong, nonatomic) NSArray<SNRSeries *> *series;

-(instancetype)initWithConfig:(SNRServerConfig *)config;
-(void)validateServerWithCompletion:(void(^)(SNRStatus *status, NSError *error))completion;
-(void)seriesWithRefresh:(BOOL)refresh andCompletion:(void(^)(NSArray<SNRSeries *> *series, NSError *error))completion;

-(void)imageForSeries:(SNRSeries *)series ofQuality:(NSInteger)quality withCompletion:(void(^)(UIImage *image))completion;
-(NSString *)generateURLWithEndpoint:(NSString *)endpoint;
@end
