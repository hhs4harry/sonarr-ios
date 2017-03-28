//
//  SNRImageView.h
//  sonarr-ios
//
//  Created by Harry Singh on 21/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNRAPIClient;

@interface SNRImageView : UIImageView
-(void)setImageWithURL:(NSURL * __nonnull)url;
-(void)setImageWithURL:(NSURL * __nonnull)url forClient:(SNRAPIClient * __nullable)client andCompletion:(void(^ __nullable)(UIImage * __nullable image))completion;
@end
