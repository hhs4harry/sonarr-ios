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
-(void)setImageWithURL:(NSURL * _Nonnull)url;
-(void)setImageWithURL:(NSURL * _Nonnull)url forClient:(SNRAPIClient * _Nullable)client andCompletion:(void(^ _Nullable)(UIImage * _Nullable image))completion;
@end
