//
//  SNRAPIClient.m
//  sonarr-ios
//
//  Created by Harry Singh on 13/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRAPIClient.h"

//#if AF3
@implementation SNRAPIClient

@synthesize status;

+(instancetype)client{
    static SNRAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [self manager];
        
        //Assuming most people will have self signed certs.
        sharedClient.securityPolicy.allowInvalidCertificates = YES;
        sharedClient.securityPolicy.validatesDomainName = NO;
        
        [[sharedClient reachabilityManager] startMonitoring];
        [[sharedClient reachabilityManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            sharedClient.status = status;
        }];
    });
    return sharedClient;
}

-(void)performPOSTCallToEndpoint:(NSString *)endpoint
                  withParameters:(NSDictionary *)params
                     withSuccess:(void (^)(id responseObject))success
                      andFailure:(void (^)(NSError *error))failure{
    [self POST:endpoint parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

-(void)performGETCallToEndpoint:(NSString *)endpoint
                 withParameters:(NSDictionary *)params
                     andSuccess:(void (^)(id responseObject))success
                     andFailure:(void (^)(NSError *error))failure{
    [self GET:endpoint parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

-(void)performPUTCallToEndpoint:(NSString *)endpoint
                 withParameters:(NSDictionary *)params
                     andSuccess:(void (^)(id responseObject))success
                     andFailure:(void (^)(NSError *))failure{
    [self PUT:endpoint parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
//#endif
