//
//  UIImage+Remote.m
//  sonarr-ios
//
//  Created by Harry Singh on 21/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "UIImage+Remote.h"
#import "SNRAPIClient.h"
#import "SNRServerManager.h"
#import "SNRServer.h"
#import <AFNetworking/AFNetworking.h>

@implementation UIImage (Remote)

+(void)imageWithURL:(NSURL *)url andCompletion:(void (^)(UIImage *))completion{
    if([url isMemberOfClass:[NSString class]]){
        url = [NSURL URLWithString:((NSString *)url)];
    }
    
    if(url){
        [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(!error && data){
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(image);
                });
            }
        }] resume];
    }else{
        completion(nil);
    }
}

+(void)imageWithURL:(NSURL *)url forClient:(SNRAPIClient *)client andCompletion:(void(^)(UIImage *image))completion{
    if([url isMemberOfClass:[NSString class]]){
        url = [NSURL URLWithString:((NSString *)url)];
    }
    
    if(url){
        [client performGETCallToEndpoint:url.absoluteString withParameters:nil andSuccess:^(id responseObject) {
            completion(responseObject);
        } andFailure:^(NSError *error) {
            completion(nil);
        }];
    }
}

@end
