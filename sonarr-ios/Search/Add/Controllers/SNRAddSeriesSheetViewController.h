//
//  SNRAddSeriesSheetViewController.h
//  sonarr-ios
//
//  Created by Harry Singh on 30/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRBaseSheetViewController.h"
@class SNRSeries;

@interface SNRAddSeriesSheetViewController : SNRBaseSheetViewController
-(void)setSeries:(SNRSeries *)series;

@end
