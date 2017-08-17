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
#import "SNRActivityIndicatorView.h"

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
    if (self.episodeRelease.state != Default) {
        return;
    }
    
    self.episodeRelease.state = Downloading;
    
    [self.downloadButton setImage:nil forState:UIControlStateNormal];
    [SNRActivityIndicatorView show:YES onView:self.downloadButton withStyle:UIActivityIndicatorViewStyleWhite];
    
    __weak typeof(self) wself = self;
    [self.delegate downloadRelease:self.episodeRelease withCompletion:^(SNRRelease * _Nullable release, NSError * _Nullable error) {
        [SNRActivityIndicatorView show:NO onView:wself.downloadButton];
        
        if (release) {
            wself.episodeRelease.state = Downloaded;
            [wself.downloadButton setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
        } else {
            wself.episodeRelease.state = Default;
            [wself.downloadButton setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
        }
    }];
}

-(void)setRelease:(SNRRelease *)release{
    _episodeRelease = release;

    if (!release.downloadAllowed) {
        self.downloadButton.alpha = 0.3f;
        self.downloadButton.userInteractionEnabled = NO;
    }
    
    // Remove activity indicator if one exists.
    [SNRActivityIndicatorView show:NO onView:self.downloadButton];
    
    switch (release.state) {
        case Default:
            [self.downloadButton setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
            break;
        case Downloading:
            [SNRActivityIndicatorView show:YES onView:self.downloadButton withStyle:UIActivityIndicatorViewStyleWhite];
            [self.downloadButton setImage:nil forState:UIControlStateNormal];
            break;
        case Downloaded:
            [self.downloadButton setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
            break;
    }
    
    self.titleLabel.text = release.title;
    self.sizeLabel.text = release.formattedSize;
    self.qualityLabel.text = [[@" " stringByAppendingString:release.quality.quality.name] stringByAppendingString:@" "];
    self.providerLabel.text = release.indexer;
    self.ageLabel.text = [release.age.stringValue stringByAppendingString:@"d"];
    
    self.qualityLabel.layer.cornerRadius = CGRectGetHeight(self.qualityLabel.frame) / 2;
    self.qualityLabel.layer.masksToBounds = YES;
}

@end
