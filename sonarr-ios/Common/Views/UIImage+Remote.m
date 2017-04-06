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

+(UIImage *)scaledForScreen:(UIImage *)image{
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    if(image.size.width > image.size.height){
        size = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));
    }else{
        size = CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
    }
    
    CGFloat ratio = MIN(image.size.width, image.size.height) / MAX(image.size.width, image.size.height);
    CGFloat a = MAX(size.width, size.height);
    CGFloat b = ratio * a;
    
    if(size.width > size.height){
        size = CGSizeMake(a, b);
    }else{
        size = CGSizeMake(b, a);
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh);
    CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), YES);
    CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), YES);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    CGAffineTransformMakeScale(a / MAX(image.size.width, image.size.height), a / MAX(image.size.width, image.size.height));
    
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}
@end
