//
//  SNRReleaseEpisodeView.m
//  Sonarr
//
//  Created by Harry Singh on 15/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRReleaseEpisodeView.h"
#import "SNRSeries.h"
#import "SNREpisode.h"
#import "SNREpisodeFile.h"
#import "SNRQuality.h"
#import "SNRAPIClient.h"
#import "SNRServer.h"

@interface SNRReleaseEpisodeView()
@property (weak, nonatomic) IBOutlet SNRImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *episodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *episodeSeasonNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *qualityLebel;
@property (weak, nonatomic) IBOutlet UILabel *airDateLabel;

@property (strong, nonatomic) SNRServer *server;
@property (strong, nonatomic) SNRSeries *series;
@property (strong, nonatomic) SNREpisode *episode;
@end

@implementation SNRReleaseEpisodeView

-(void)configureWithServer:(SNRServer *)server series:(SNRSeries *)series andEpisode:(SNREpisode *)episode {
    self.server = server;
    self.series = series;
    self.episode = episode;
    
    __block SNRImage *seriesImage = [series imageWithType:ImageTypePoster];
    if (seriesImage.image) {
        self.imageView.image = seriesImage.image;
    } else {
        NSURL *url = [NSURL URLWithString:seriesImage.url];
        if (url) {
            [self.imageView setImageWithURL:url forClient:server.client andCompletion:^(UIImage * _Nullable image) {
                seriesImage.image = image;
            }];
        }
    }
    
    self.titleLabel.text = series.title;
    self.episodeLabel.text = episode.title;
    self.episodeSeasonNumberLabel.text = episode.seasonxEpisode;
    self.airDateLabel.text = episode.formattedAirDate;
    
    if (episode.hasFile && episode.file) {
        self.sizeLabel.text = episode.file.formattedSize;
        self.qualityLebel.text = [[@" " stringByAppendingString:episode.file.quality.quality.name] stringByAppendingString:@" "];

        self.qualityLebel.layer.cornerRadius = CGRectGetHeight(self.qualityLebel.frame) / 2;
        self.qualityLebel.layer.masksToBounds = YES;
    } else {
        self.qualityLebel.hidden = YES;
        self.sizeLabel.text = @"Missing";
        self.sizeLabel.textColor = [UIColor redColor];
    }
}
- (IBAction)closeButtonTouchUpInside:(id)sender {
    [self.delegate closeButtonTouchUpInside:sender];
}

@end
