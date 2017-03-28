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

@interface SNRImageView()
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@end

@implementation SNRImageView

-(void)setImage:(UIImage *)image{
    [super setImage:image];
    
    [SNRActivityIndicatorView show:NO onView:self];
}

-(void)setImageWithURL:(NSURL *)url{
    [self setImageWithURL:url forClient:nil andCompletion:nil];
}

-(void)setImageWithURL:(NSURL *)url forClient:(SNRAPIClient *)client andCompletion:(void(^)(UIImage *image))completion{
    NSInteger tag = self.tag + 1;
    self.tag = tag;
    
    [SNRActivityIndicatorView show:YES onView:self];
    
    __weak typeof(self) wself = self;
    if(client){
        [UIImage imageWithURL:url forClient:client andCompletion:^(UIImage *image) {
            if(tag == self.tag){
                if(image){
                    __strong typeof(wself) sself = wself;
                    [SNRActivityIndicatorView show:NO onView:self];
                    sself.image = image;
                }
            }
            
            if(completion){
                completion(image);
            }
        }];
    }else{
        [UIImage imageWithURL:url andCompletion:^(UIImage *image) {
            if(tag == self.tag){
                if(image){
                    __strong typeof(wself) sself = wself;
                    [SNRActivityIndicatorView show:NO onView:self];
                    sself.image = image;
                }
            }
            
            if(completion){
                completion(image);
            }
        }];
    }
}

@end
