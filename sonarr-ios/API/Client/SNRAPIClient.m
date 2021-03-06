//
//  SNRAPIClient.m
//  sonarr-ios
//
//  Created by Harry Singh on 13/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//
#import "SNRAPIClient.h"
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#include <arpa/inet.h>

@interface SNRAPIClient()
@property (assign, nonatomic) NetworkStatus networkStatus;
@end

//#if AF3
@implementation SNRAPIClient

@synthesize networkStatusBlock;

+(instancetype)client{
    static SNRAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [self manager];
        [sharedClient setupClient];
    });
    return sharedClient;
}

-(instancetype)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if(self){
        [self setupClient];
    }
    return self;
}

-(void)setupClient{
    //Assuming most people will have self signed certs.
    self.securityPolicy.allowInvalidCertificates = YES;
    self.securityPolicy.validatesDomainName = NO;
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.responseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[[AFImageResponseSerializer serializer], [AFJSONResponseSerializer serializer]]];
    
    //Set challenge block to allow invalid / self signed certs
    [self setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        return NSURLSessionResponseAllow;
    }];

    self.reachabilityManager = [AFNetworkReachabilityManager managerForDomain:self.baseURL.absoluteString];
    [self.reachabilityManager startMonitoring];
    
    __weak typeof(self) wself = self;
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        __strong typeof(self) sself = wself;
        
        if(sself.networkStatusBlock){
            sself.networkStatusBlock(status);
        }
        sself.networkStatus = status;
    }];
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

-(void)performDELETECallToEndpoint:(NSString *)endpoint
                    withParameters:(NSDictionary *)params
                        andSuccess:(void (^)(id responseObject))success
                        andFailure:(void (^)(NSError *error))failure{
    [self DELETE:endpoint parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
//#endif
