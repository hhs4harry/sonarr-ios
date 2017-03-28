//
//  SNRNetworkProtocol.h
//  sonarr-ios
//
//  Created by Harry Singh on 13/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NetworkStatusUnrechable = 0,
    NetworkStatusRechable
} NetworkStatus;

@protocol SNRNetworkProtocol <NSObject>

@required

@property (readonly) NetworkStatus networkStatus;

+(instancetype)client;
-(instancetype)initWithBaseURL:(NSURL *)url;

-(void)performGETCallToEndpoint:(NSString *)endpoint
                  withParameters:(NSDictionary *)params
                      andSuccess:(void (^)(id responseObject))success
                      andFailure:(void (^)(NSError *error))failure;

-(void)performPOSTCallToEndpoint:(NSString *)endpoint
                  withParameters:(NSDictionary *)params
                     withSuccess:(void (^)(id responseObject))success
                      andFailure:(void (^)(NSError *error))failure;

-(void)performPUTCallToEndpoint:(NSString *)endpoint
                 withParameters:(NSDictionary *)params
                     andSuccess:(void (^)(id responseObject))success
                     andFailure:(void (^)(NSError *))failure;

@end
