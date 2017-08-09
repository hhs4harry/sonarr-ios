//
//  SNRImageView.m
//  sonarr-ios
//
//  Created by Harry Singh on 21/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRImageView.h"
#import "UIImage+Remote.h"
#import "SNRActivityIndicatorView.h"
#import "SNRAPIClient.h"
#import "SNRServerManager.h"
#import "SNRServer.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>

@interface SNRImageView()
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@end

@implementation SNRImageView

-(void)setImageWithURL:(NSURL *)url{
    [self setImageWithURL:url forClient:nil andCompletion:nil];
}

-(void)setImageWithURL:(NSURL *)url forClient:(SNRAPIClient *)client andCompletion:(void(^)(UIImage *image))completion{
    [self sd_cancelCurrentImageLoad];
    
    url = [NSURL URLWithString:[client.baseURL.absoluteString stringByAppendingString: url.absoluteString]];
    [self sd_setImageWithURL:url placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates ^ SDWebImageScaleDownLargeImages progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        completion(image);
    }];
}

@end
