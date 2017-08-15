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

@interface SNRReleasesViewController : SNRBaseSheetViewController
-(void)setServer:(SNRServer *)server series:(SNRSeries *)series andEpisode:(SNREpisode *)episode;
@end
