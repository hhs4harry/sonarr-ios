//
//  SNRAddSeriesDetailsTableViewCell.m
//  sonarr-ios
//
//  Created by Harry Singh on 3/04/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRAddSeriesDetailsTableViewCell.h"
#import "SNRSeries.h"

@interface SNRAddSeriesDetailsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (strong, nonatomic) SNRSeries *series;
@end

@implementation SNRAddSeriesDetailsTableViewCell

-(void)setSeries:(SNRSeries *)series seriesDetailType:(SeriesDetail)type{
    self.series = series;
    
    switch (type) {
        case SeriesDetailPath:
            self.nameLabel.text = @"Path";
            break;
        case SeriesDetailMonitor:
            self.nameLabel.text = @"Monitor";
            break;
        case SeriesDetailProfile:
            self.nameLabel.text = @"Quality Profile";
            break;
        case SeriesDetailSeriesType:
            self.nameLabel.text = @"Type";
            break;
        default:
            return;
            break;
    }
}



@end
