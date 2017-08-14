//
//  SNREpisodeCell.m
//  sonarr-ios
//
//  Created by Harry Singh on 18/06/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNREpisodeCell.h"
#import "SNREpisode.h"
#import "SNREpisodeFile.h"
#import "SNRQuality.h"

@interface SNREpisodeCell()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *qualityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) SNREpisode *episode;
@end

@implementation SNREpisodeCell

-(void)setEpisode:(SNREpisode *)episode{
    _episode = episode;
    
    self.numberLabel.text = episode.episodeNumber.stringValue;
    self.titleLabel.text = episode.title ? : @"";
    self.qualityLabel.text = episode.episodeFileStatus;
    self.dateLabel.text = episode.formattedAirDate;

    if (!episode.monitored) {
        self.numberLabel.alpha = 0.5f;
        self.titleLabel.alpha = 0.5f;
        self.qualityLabel.alpha = 0.5;
    }
}

@end
