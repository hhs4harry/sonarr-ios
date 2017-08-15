//
//  SNRAddSeriesDetailsSwitchTableViewCell.h
//  sonarr-ios
//
//  Created by Harry Singh on 5/04/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRAddSeriesDetailsTableViewCell.h"
@class SNRSeries;

@interface SNRAddSeriesDetailsSwitchTableViewCell : UITableViewCell
-(void)setSeries:(SNRSeries *)series;
@end
