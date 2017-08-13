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
#import "SNRConstants.h"

CGFloat const kTopBottomSpace = 24.0;
CGFloat const kTintViewColorAlpha = 0.7;
#define kMinParallaxViewHeight [UIScreen mainScreen].bounds.size.height * 0.2
#define kMaxParallaxViewHeight [UIScreen mainScreen].bounds.size.height * 0.7

@interface SNRParallaxView()
@property (weak, nonatomic) IBOutlet SNRImageView *parallaxImageView;
@property (weak, nonatomic) IBOutlet SNRImageView *seriesImageView;
@property (weak, nonatomic) IBOutlet UIView *tintView;
@property (weak, nonatomic) IBOutlet UILabel *seriesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *seasonLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parallaxViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seriesImageViewHeightConstraint;
@property (assign, nonatomic) CGFloat seriesInitialHeight;
@end

@implementation SNRParallaxView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
   return [super initWithCoder:aDecoder];
}

-(void)configureWithSeries:(SNRSeries *)series forServer:(SNRServer *)server{
    __block SNRImage *parallaxImage = [series imageWithType:ImageTypeFanArt];
    __block SNRImage *seriesImage = [series imageWithType:ImageTypePoster];
    
    if (parallaxImage.image) {
        self.parallaxImageView.image = parallaxImage.image;
    } else {
        NSURL *parallaxImageURL = [NSURL URLWithString:[server generateURLWithEndpoint:parallaxImage.url]];
        [self.parallaxImageView setImageWithURL:parallaxImageURL forClient:[SNRServerManager manager].activeServer.client andCompletion:^(UIImage * _Nullable image) {
            parallaxImage.image = image;
        }];
    }
    
    if (seriesImage.image) {
        self.seriesImageView.image = seriesImage.image;
    } else {
        NSURL *imageURL =  [NSURL URLWithString:[server generateURLWithEndpoint:seriesImage.url]];
        [self.seriesImageView setImageWithURL:imageURL forClient:server.client andCompletion:^(UIImage * _Nullable image) {
            seriesImage.image = image;
        }];
    }
    
    self.seriesTitleLabel.text = series.title;
    self.seasonLabel.text = series.seriesInfo;
    
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself animateToDefaultState:NO];
    });
}

-(void)animateToDefaultState:(BOOL)animate{
    CGFloat frameWidth = CGRectGetWidth(self.frame);
    CGSize imageSize = self.parallaxImageView.image.size;
    
    if (CGSizeEqualToSize(CGSizeZero, imageSize)) {
        imageSize = kBannerSize;
    }
    
    CGFloat ratio = MIN(imageSize.height, imageSize.width) / MAX(imageSize.height, imageSize.width);
    
    self.parallaxViewHeightConstraint.constant = ratio * frameWidth;
    self.seriesImageViewHeightConstraint.constant = self.parallaxViewHeightConstraint.constant - kTopBottomSpace;

    if (animate) {
        [UIView animateWithDuration:0.3 animations:^{
            self.seriesImageView.alpha = 1.0;
            self.seriesTitleLabel.alpha = 1.0;
            self.seasonLabel.alpha = 1.0;
            self.tintView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kTintViewColorAlpha];
            [self.superview layoutIfNeeded];
        }];
    }
    
    if (!self.seriesInitialHeight || floorf(self.seriesInitialHeight) == 0.0) {
        self.seriesInitialHeight = self.seriesImageViewHeightConstraint.constant;
    }
}

-(BOOL)didPan:(UIPanGestureRecognizer *)urgi {
    if (urgi.state == UIGestureRecognizerStateEnded) {
        if (self.parallaxViewHeightConstraint.constant > (self.seriesInitialHeight + kTopBottomSpace)) {
            [self animateToDefaultState:YES];
            return YES;
        }
        return NO;
    } else {
        CGPoint velocity = [urgi velocityInView:self];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / ((self.parallaxViewHeightConstraint.constant >= 150) ? (self.parallaxViewHeightConstraint.constant - 100) : 100);
        CGFloat slideFactor = 1.0 * slideMult;
        
        BOOL panned = NO;
        
        if (0 > velocity.y &&
            self.parallaxViewHeightConstraint.constant - slideFactor >= kMinParallaxViewHeight) {
                self.parallaxViewHeightConstraint.constant -= slideFactor;
            panned = YES;
        } else if (0 < velocity.y &&
                   self.parallaxViewHeightConstraint.constant - slideFactor <= kMaxParallaxViewHeight){
            self.parallaxViewHeightConstraint.constant += slideFactor;
            panned = YES;
        }
        
        if (self.parallaxViewHeightConstraint.constant - kTopBottomSpace <= self.seriesInitialHeight) {
            self.seriesImageViewHeightConstraint.constant = self.parallaxViewHeightConstraint.constant - kTopBottomSpace;
        }
        
        self.seriesImageView.alpha = 1.0 - ((self.parallaxViewHeightConstraint.constant - kTopBottomSpace - self.seriesInitialHeight) / 100);
        self.seriesTitleLabel.alpha = self.seriesImageView.alpha;
        self.seasonLabel.alpha = self.seriesImageView.alpha;
        self.tintView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:MIN(self.seriesImageView.alpha, kTintViewColorAlpha)];
        
        return panned;
    }
    return NO;
}

@end
