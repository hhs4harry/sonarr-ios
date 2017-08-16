//
//  SNRReleaseEpisodeView.h
//  Sonarr
//
//  Created by Harry Singh on 15/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNRImageView.h"
@class SNRServer;
@class SNREpisode;
@class SNRSeries;

@protocol SNRReleaseEpisodeViewProtocol
-(void)closeButtonTouchUpInside:(id _Nonnull)sender;

@end

@interface SNRReleaseEpisodeView : UIView
@property (weak, nonatomic, nullable) id<SNRReleaseEpisodeViewProtocol> delegate;

-(void)configureWithServer:(SNRServer * _Nonnull)server series:(SNRSeries * _Nonnull)series andEpisode:(SNREpisode * _Nonnull)episode;
@end
