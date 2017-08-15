//
//  SNRReleaseCell.m
//  Sonarr
//
//  Created by Harry Singh on 14/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRReleaseCell.h"
#import "SNRRelease.h"
#import "SNRQuality.h"

@interface SNRReleaseCell()
@property (strong, nonatomic) SNRRelease *episodeRelease;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *qualityLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *providerLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

@end

@implementation SNRReleaseCell

- (IBAction)downloadButtonTouchUpInside:(id)sender {
    
}

-(void)setRelease:(SNRRelease *)release{
    _episodeRelease = release;
    
    self.titleLabel.text = release.title;
    self.sizeLabel.text = release.formattedSize;
    self.qualityLabel.text = release.quality.quality.name;
    self.providerLabel.text = release.indexer;
    self.ageLabel.text = [release.age.stringValue stringByAppendingString:@"d"];
}

@end
