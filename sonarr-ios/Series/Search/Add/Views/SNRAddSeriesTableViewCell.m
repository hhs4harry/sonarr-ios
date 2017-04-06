//
//  SNRAddSeriesTableViewCell.m
//  sonarr-ios
//
//  Created by Harry Singh on 31/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRAddSeriesTableViewCell.h"
#import "SNRImageView.h"

@interface SNRAddSeriesTableViewCell ()
@property (weak, nonatomic) IBOutlet SNRImageView *seriesImageView;
@property (weak, nonatomic) IBOutlet SNRImageView *parallaxImageView;
@end

@implementation SNRAddSeriesTableViewCell

-(CGFloat)imageToViewRatio{
    return CGRectGetHeight(self.parallaxImageView.frame) / CGRectGetHeight(self.frame);
}

@end
