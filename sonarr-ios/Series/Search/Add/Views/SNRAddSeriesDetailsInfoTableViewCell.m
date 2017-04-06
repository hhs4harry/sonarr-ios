//
//  SNRAddSeriesDetailsInfoTableViewCell.m
//  sonarr-ios
//
//  Created by Harry Singh on 5/04/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRAddSeriesDetailsInfoTableViewCell.h"
#import "SNRSeries.h"

@interface SNRAddSeriesDetailsInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;

@end

@implementation SNRAddSeriesDetailsInfoTableViewCell

-(void)setSeries:(SNRSeries *)series{
    self.infoTextView.text = series.overview;
}

@end
