//
//  SNRSearchSeriesTableViewCell.m
//  sonarr-ios
//
//  Created by Harry Singh on 27/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRSearchSeriesTableViewCell.h"
#import "SNRImageView.h"
#import "SNRSeries.h"
#import "SNRImage.h"
#import "SNRServer.h"

@interface SNRSearchSeriesTableViewCell()
@property (weak, nonatomic) IBOutlet SNRImageView *parallaxImageView;
@property (weak, nonatomic) IBOutlet SNRImageView *seriesImageView;
@property (weak, nonatomic) IBOutlet UILabel *seriesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *seasonCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *seriesAiredLabel;
@property (strong, nonatomic) SNRSeries *series;

@end

@implementation SNRSearchSeriesTableViewCell

-(void)setSeries:(SNRSeries *)series forServer:(SNRServer *)server{
    self.series = series;
    
    self.seriesTitleLabel.text = self.series.title;
    self.seriesAiredLabel.text = series.scheduleInfo;
    self.seasonCountLabel.text = series.seriesInfo;
    
    SNRImage *parallax = [series imageWithType:ImageTypeFanArt];
    SNRImage *seriesImage = [series imageWithType:ImageTypePoster];
    
    if (!parallax && !seriesImage) {
        return;
    }
    
    NSURL *paralaxImageURL = [NSURL URLWithString:parallax.url];
    NSURL *imageURL =  [NSURL URLWithString:seriesImage.url];
    
    if (paralaxImageURL) {
        [self.parallaxImageView setImageWithURL:paralaxImageURL];
    }
    
    if (imageURL) {
        [self.seriesImageView setImageWithURL:imageURL];
    }
}

@end
