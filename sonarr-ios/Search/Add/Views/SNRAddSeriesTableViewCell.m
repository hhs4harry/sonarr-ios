//
//  SNRAddSeriesTableViewCell.m
//  sonarr-ios
//
//  Created by Harry Singh on 31/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRAddSeriesTableViewCell.h"
#import "SNRImageView.h"
#import "SNRSeries.h"

@interface SNRAddSeriesTableViewCell ()
@property (weak, nonatomic) IBOutlet SNRImageView *seriesImageView;
@property (weak, nonatomic) IBOutlet SNRImageView *parallaxImageView;
@property (weak, nonatomic) IBOutlet UILabel *seriesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *seasonCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *seriesAiredLabel;
@property (strong, nonatomic) SNRSeries *series;
@end

@implementation SNRAddSeriesTableViewCell

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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    return;
}

@end
