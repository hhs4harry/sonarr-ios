//
//  UIImage+Remote.h
//  sonarr-ios
//
//  Created by Harry Singh on 21/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNRAPIClient;

@interface UIImage (Remote)
+(void)imageWithURL:(NSURL *)url forClient:(SNRAPIClient *)client andCompletion:(void(^)(UIImage *image))completion;
+(void)imageWithURL:(NSURL *)url andCompletion:(void(^)(UIImage *image))completion;

@end
