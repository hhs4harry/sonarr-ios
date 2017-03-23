//
//  SNRImageView.m
//  sonarr-ios
//
//  Created by Harry Singh on 21/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRImageView.h"
#import "UIImage+Remote.h"

@interface SNRImageView()
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@end

@implementation SNRImageView

-(void)setImageWithURL:(NSURL *)url{
    self.activityIndicator.hidden = NO;
    
    __weak typeof(self) wself = self;
    [UIImage imageWithURL:url andCompletion:^(UIImage *image) {
        wself.activityIndicator.hidden = YES;
        wself.image = image;
    }];
}

-(UIActivityIndicatorView *)activityIndicator{
    if(!!_activityIndicator){
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_activityIndicator startAnimating];
        [self addSubview:_activityIndicator];
        
        [[NSLayoutConstraint constraintWithItem:_activityIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:0.0f constant:1.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:_activityIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:0.0f constant:1.0f] setActive:YES];
    }
    
    return _activityIndicator;
}

@end
