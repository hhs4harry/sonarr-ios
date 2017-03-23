//
//  SNRSeriesTableViewCell.m
//  sonarr-ios
//
//  Created by Harry Singh on 21/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRSeriesTableViewCell.h"
#import "SNRImageView.h"
#import "SNRSeries.h"
#import "SNRServer.h"
#import "SNRImage.h"
#import "UIImage+Remote.h"

@interface SNRSeriesTableViewCell()
@property (weak, nonatomic) IBOutlet SNRImageView *parallaxImageView;
@property (weak, nonatomic) IBOutlet SNRImageView *seriesImageView;

@end

@implementation SNRSeriesTableViewCell

-(void)setSeries:(SNRSeries *)series forServer:(SNRServer *)server{
    self.parallaxImageView.image = nil;
    self.seriesImageView.image = nil;
    
    NSURL *imageURL =  [NSURL URLWithString:[server generateURLWithEndpoint:((SNRImage *)series.images.lastObject).url]];
    NSURL *paralaxImageURL = [NSURL URLWithString:[server generateURLWithEndpoint:((SNRImage *)series.images.firstObject).url]];
    
    [self.seriesImageView setImageWithURL:imageURL];
    [self.parallaxImageView setImageWithURL:paralaxImageURL];
}

@end
