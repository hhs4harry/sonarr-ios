//
//  SNRSeriesAddTableViewCell.m
//  sonarr-ios
//
//  Created by Harry Singh on 27/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRSeriesAddTableViewCell.h"
#import "SNRImageView.h"
#import "SNRSeries.h"
#import "SNRImage.h"

@interface SNRSeriesAddTableViewCell()
@property (weak, nonatomic) IBOutlet SNRImageView *parallaxImageView;
@property (weak, nonatomic) IBOutlet SNRImageView *seriesImageView;
@property (weak, nonatomic) IBOutlet UILabel *seriesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *seasonCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *seriesAiredLabel;
@property (strong, nonatomic) SNRSeries *series;

@end

@implementation SNRSeriesAddTableViewCell

-(void)setSeries:(SNRSeries *)series forServer:(SNRServer *)server{
    self.parallaxImageView.tag = self.tag + 1;
    self.seriesImageView.tag = self.tag + 1;
    self.tag = self.parallaxImageView.tag;
    
    self.series = series;
    
    self.seriesTitleLabel.text = self.series.title;
    self.seriesAiredLabel.text = series.scheduleInfo;
    self.seasonCountLabel.text = series.seriesInfo;
    
    __block SNRImage *parallax = series.images.firstObject;
    __block SNRImage *seriesImage = series.images.lastObject;
    
    if(parallax.image && seriesImage.image){
        self.parallaxImageView.image = parallax.image;
        self.seriesImageView.image = seriesImage.image;
        return;
    }
    
    if(parallax.image){
        self.parallaxImageView.image = parallax.image;
    }else{
        NSURL *paralaxImageURL = [NSURL URLWithString:parallax.url];
        [self.parallaxImageView setImageWithURL:paralaxImageURL forClient:nil andCompletion:^(UIImage * _Nullable image) {
            parallax.image = image;
        }];
    }
    
    if(seriesImage.image){
        self.seriesImageView.image = seriesImage.image;
    }else{
        NSURL *imageURL =  [NSURL URLWithString:seriesImage.url];
        [self.seriesImageView setImageWithURL:imageURL forClient:nil andCompletion:^(UIImage * _Nullable image) {
            seriesImage.image = image;
        }];
    }
}

//- (IBAction)addSeriesTouchUpInside:(id)sender {
//    if(self.delegate){
//        [self.delegate didTapAddSeries:self.series];
//    }
//}

@end
