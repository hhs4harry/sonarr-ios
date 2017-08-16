//
//  SNRReleasesViewController.h
//  Sonarr
//
//  Created by Harry Singh on 14/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRBaseSheetViewController.h"
#import "SNRSeries.h"
#import "SNREpisode.h"
#import "SNRServer.h"

@protocol SNRReleaseViewControllerProtocol
-(void)didDismissWithError:(NSError * _Nonnull)error;
@end

@interface SNRReleasesViewController : SNRBaseSheetViewController
@property (weak, nonatomic, nullable) id<SNRReleaseViewControllerProtocol> delegate;

-(void)setServer:(SNRServer * _Nonnull)server series:(SNRSeries * _Nonnull)series andEpisode:(SNREpisode * _Nonnull)episode;
@end
