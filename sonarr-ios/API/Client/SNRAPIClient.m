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
    
    struct sockaddr_in address;
    address.sin_len = sizeof(address);
    address.sin_family = AF_INET;
    address.sin_port = htons(self.baseURL.port.integerValue);
    address.sin_addr.s_addr = inet_addr([[self lookupHostIPAddressForURL:self.baseURL] UTF8String]);
    self.reachabilityManager = [AFNetworkReachabilityManager managerForAddress:&address];
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

- (NSString *)lookupHostIPAddressForURL:(NSURL*)url{
    if(![[url.host componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@""].length){
        return url.host;
    }
    
    // Ask the unix subsytem to query the DNS
    struct hostent *remoteHostEnt = gethostbyname([[url host] UTF8String]);
    // Get address info from host entry
    struct in_addr *remoteInAddr = (struct in_addr *) remoteHostEnt->h_addr_list[0];
    // Convert numeric addr to ASCII string
    char *sRemoteInAddr = inet_ntoa(*remoteInAddr);
    // hostIP
    NSString* hostIP = [NSString stringWithUTF8String:sRemoteInAddr];
    return hostIP;
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
