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
#import "UIColor+App.h"

@interface SNRSeriesTableViewCell()
@property (weak, nonatomic) IBOutlet SNRImageView *parallaxImageView;
@property (weak, nonatomic) IBOutlet SNRImageView *seriesImageView;
@property (weak, nonatomic) IBOutlet UILabel *seriesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *seasonCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *seriesAiredLabel;
@property (strong, nonatomic) SNRSeries *series;
@property (strong, nonatomic) UIScrollView *scrollView;
@end

const CGFloat PARALLAXRATIO = 0.25;

@implementation SNRSeriesTableViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.clipsToBounds = YES;
}

-(void)prepareForReuse{
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
        __weak typeof(self) wself = self;
        NSURL *paralaxImageURL = [NSURL URLWithString:[server generateURLWithEndpoint:parallax.url]];
        [self.parallaxImageView setImageWithURL:paralaxImageURL forClient:server.client andCompletion:^(UIImage * _Nullable image) {
            [wself scrollViewDidScroll:wself.scrollView];

            parallax.image = image;
        }];
    }
    
    if(seriesImage.image){
        self.seriesImageView.image = seriesImage.image;
    }else{
        NSURL *imageURL =  [NSURL URLWithString:[server generateURLWithEndpoint:seriesImage.url]];
        [self.seriesImageView setImageWithURL:imageURL forClient:server.client andCompletion:^(UIImage * _Nullable image) {
            seriesImage.image = image;
        }];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.scrollView){
        self.scrollView = scrollView;
    }
    
    CGFloat contentOffSet, cellOffSet, percent, extraHeight;
    contentOffSet = scrollView.contentOffset.y;
    cellOffSet = CGRectGetMinY(self.frame) - contentOffSet;
    percent = (cellOffSet + CGRectGetHeight(self.frame)) / (CGRectGetHeight(scrollView.frame) + CGRectGetHeight(self.frame));
    extraHeight = CGRectGetHeight(self.frame) * (PARALLAXRATIO);
    
    CGRect parallaxRect = self.parallaxImageView.frame;
    parallaxRect.origin.y = -extraHeight * percent;
    self.parallaxImageView.frame = parallaxRect;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
}
@end
