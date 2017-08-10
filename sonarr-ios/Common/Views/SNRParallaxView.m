//
//  SNRParallaxView.m
//  Sonarr
//
//  Created by Harry Singh on 9/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRParallaxView.h"
#import "SNRImageView.h"
#import "SNRSeries.h"
#import "SNRServerManager.h"
#import "SNRAPIClient.h"
#import "SNRServer.h"

@interface SNRParallaxView()
@property (weak, nonatomic) IBOutlet SNRImageView *parallaxImageView;
@property (weak, nonatomic) IBOutlet SNRImageView *seriesImageView;
@property (weak, nonatomic) IBOutlet UILabel *seriesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *seasonLabel;
@end

@implementation SNRParallaxView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
   return [super initWithCoder:aDecoder];
}

-(void)configureWithSeries:(SNRSeries *)series{
    SNRImage *parallaxImage = [series imageWithType:ImageTypeBanner];
    SNRImage *seriesImage = [series imageWithType:ImageTypePoster];
    
    if (parallaxImage.image) {
        self.parallaxImageView.image = parallaxImage.image;
    } else {
        [self.parallaxImageView setImageWithURL:[NSURL URLWithString:[series imageWithType:ImageTypeBanner].url] forClient:[SNRServerManager manager].activeServer.client andCompletion:^(UIImage * _Nullable image) {
            
        }];
    }
    
    if (seriesImage.image) {
        self.seriesImageView.image = seriesImage.image;
    }
}

@end
