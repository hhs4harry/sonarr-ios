//
//  UIImage+Remote.m
//  sonarr-ios
//
//  Created by Harry Singh on 21/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "UIImage+Remote.h"
#import "SNRAPIClient.h"

@implementation UIImage (Remote)

+(void)imageWithURL:(NSURL *)url andCompletion:(void(^)(UIImage *image))completion{
    if([url isMemberOfClass:[NSString class]]){
        url = [NSURL URLWithString:((NSString *)url)];
    }
    
    if(url){
        SNRAPIClient *client = [SNRAPIClient client];
        AFHTTPResponseSerializer *currResponse = client.responseSerializer;
        client.responseSerializer = [AFImageResponseSerializer serializer];
        
        [[SNRAPIClient client] performGETCallToEndpoint:url.absoluteString withParameters:nil andSuccess:^(id responseObject) {
            client.responseSerializer = currResponse;
            completion(responseObject);
        } andFailure:^(NSError *error) {
            client.responseSerializer = currResponse;
            completion(nil);
        }];
    }
}

@end
