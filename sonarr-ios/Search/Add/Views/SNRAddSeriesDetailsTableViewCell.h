//
//  SNRAddSeriesDetailsTableViewCell.h
//  sonarr-ios
//
//  Created by Harry Singh on 3/04/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNRSeries;

typedef enum : NSUInteger {
    SeriesDetailPath = 0,
    SeriesDetailMonitor,
    SeriesDetailProfile,
    SeriesDetailSeriesType,
    SeriesDetailCount
} SeriesDetail;

@interface SNRAddSeriesDetailsTableViewCell : UITableViewCell
-(void)setSeries:(SNRSeries *)series seriesDetailType:(SeriesDetail)type;
-(void)becomeFirstResponder;
@end
