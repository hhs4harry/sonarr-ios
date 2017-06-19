//
//  SNREpisodeCell.m
//  sonarr-ios
//
//  Created by Harry Singh on 18/06/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNREpisodeCell.h"
#import "SNREpisode.h"

@interface SNREpisodeCell()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *qualityLabel;
@property (strong, nonatomic) SNREpisode *episode;
@end

@implementation SNREpisodeCell

-(void)setEpisode:(SNREpisode *)episode{
    _episode = episode;
    
    self.numberLabel.text = episode.episodeNumber.stringValue;
    self.titleLabel.text = episode.title ? : @"";
    self.qualityLabel.text = @"";
}

@end
