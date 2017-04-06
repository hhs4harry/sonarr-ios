//
//  SNRAddSeriesDetailsSwitchTableViewCell.m
//  sonarr-ios
//
//  Created by Harry Singh on 5/04/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRAddSeriesDetailsSwitchTableViewCell.h"
#import "SNRSeries.h"

@interface SNRAddSeriesDetailsSwitchTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *detailsSwitch;
@property (strong, nonatomic) SNRSeries *series;
@end

@implementation SNRAddSeriesDetailsSwitchTableViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.titleLabel.text = @"Monitor";
}

-(void)setSeries:(SNRSeries *)series{
    _series = series;
    series.monitored = self.detailsSwitch.isOn;
}

- (IBAction)switchTouchUpInside:(id)sender {
    self.series.monitored = ((UISwitch *)sender).isOn;
}

@end
