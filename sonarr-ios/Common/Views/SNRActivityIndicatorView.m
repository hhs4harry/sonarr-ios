//
//  SNRActivityIndicatorView.m
//  sonarr-ios
//
//  Created by Harry Singh on 23/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRActivityIndicatorView.h"

@implementation SNRActivityIndicatorView

-(instancetype)init{
    self = [super initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self startAnimating];
    return self;
}

+(instancetype)show:(BOOL)show onView:(id)view{
    __block SNRActivityIndicatorView *instance = [view viewWithTag:NSIntegerMax - 1];
    
    if(!instance){
        instance = [[self alloc] init];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!instance.isAnimating){
                [instance startAnimating];
            }
            
            instance.hidden = !show;
            [instance setTag:NSIntegerMax - 1];
            instance.translatesAutoresizingMaskIntoConstraints = NO;
            
            [view addSubview:instance];
            
            [[NSLayoutConstraint constraintWithItem:instance attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f] setActive:YES];
            [[NSLayoutConstraint constraintWithItem:instance attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f] setActive:YES];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [instance startAnimating];
            instance.hidden = !show;
        });
    }

    return instance;
}

@end
