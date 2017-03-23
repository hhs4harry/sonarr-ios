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
@property (weak, nonatomic) IBOutlet UILabel *seriesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *seasonCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *seriesAiredLabel;
@property (strong, nonatomic) SNRSeries *series;
@property (strong, nonatomic) NSOperationQueue *loadingQueue;
@end

@implementation SNRSeriesTableViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.loadingQueue = [[NSOperationQueue alloc] init];    
    self.loadingQueue.underlyingQueue = dispatch_get_main_queue();
}

-(void)prepareForReuse{
    [self.loadingQueue cancelAllOperations];
    
    SNRImage *parallax = self.series.images.firstObject;
    SNRImage *seriesImage = self.series.images.lastObject;
    
    if(parallax.image && seriesImage.image){
        self.parallaxImageView.image = nil;
        self.seriesImageView.image = nil;
        
        [super prepareForReuse];
        return;
    }
    
    if(!parallax.image){
        parallax.image = self.parallaxImageView.image;
    }
    
    if(!seriesImage.image){
        seriesImage.image = self.seriesImageView.image;
    }
    
    self.parallaxImageView.image = nil;
    self.seriesImageView.image = nil;
    
    [super prepareForReuse];
}

-(void)setSeries:(SNRSeries *)series forServer:(SNRServer *)server{
    self.parallaxImageView.tag = self.tag + 1;
    self.seriesImageView.tag = self.tag + 1;
    self.tag = self.parallaxImageView.tag;
    
    self.series = series;
    
    self.seriesTitleLabel.text = self.series.title;
    self.seriesAiredLabel.text = series.scheduleInfo;
    self.seasonCountLabel.text = series.seriesInfo;
    
    SNRImage *parallax = series.images.firstObject;
    SNRImage *seriesImage = series.images.lastObject;
    
    if(parallax.image && seriesImage.image){
        self.parallaxImageView.image = parallax.image;
        self.seriesImageView.image = seriesImage.image;
        return;
    }
    
    if(parallax.image){
        self.parallaxImageView.image = parallax.image;
    }else{
        [self.loadingQueue addOperationWithBlock:^{
            NSURL *paralaxImageURL = [NSURL URLWithString:[server generateURLWithEndpoint:parallax.url]];
            [self.parallaxImageView setImageWithURL:paralaxImageURL];
        }];
    }
    
    if(seriesImage.image){
        self.seriesImageView.image = seriesImage.image;
    }else{
        [self.loadingQueue addOperationWithBlock:^{
            NSURL *imageURL =  [NSURL URLWithString:[server generateURLWithEndpoint:seriesImage.url]];
            [self.seriesImageView setImageWithURL:imageURL];
        }];
    }
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
}
@end
