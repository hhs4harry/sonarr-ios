//
//  SNRActivityIndicatorView.m
//  sonarr-ios
//
//  Created by Harry Singh on 23/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRActivityIndicatorView.h"

@interface SNRActivityIndicatorView()
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@end

@implementation SNRActivityIndicatorView

-(instancetype)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style{
    self = [super init];
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    self.indicator.color = [UIColor whiteColor];
    
    if(style == UIActivityIndicatorViewStyleGray){
        self.indicator.color = [UIColor blackColor];
    }
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.indicator];
    
    self.indicator.translatesAutoresizingMaskIntoConstraints = NO;
    [[NSLayoutConstraint constraintWithItem:self.indicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.indicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f] setActive:YES];
    return self;
}

+(instancetype)show:(BOOL)show onView:(id)view withStyle:(UIActivityIndicatorViewStyle)style andTint:(BOOL)tint{
    __block SNRActivityIndicatorView *instance = [view viewWithTag:NSIntegerMax - 1];
    
    if(!instance && !show){
        return nil;
    }else if(!instance && show){
        instance = [[self alloc] initWithActivityIndicatorStyle:style];
        
        if(tint){
            instance.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        }
        
        void(^finishUp)(void) = ^() {
            if(!instance.indicator.isAnimating){
                [instance.indicator startAnimating];
            }
            
            instance.hidden = !show;
            [instance setTag:NSIntegerMax - 1];
            instance.translatesAutoresizingMaskIntoConstraints = NO;
            
            [view addSubview:instance];
            [view bringSubviewToFront:instance];
            
            [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:@{@"v" : instance}]];
            [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v]|" options:0 metrics:nil views:@{@"v" : instance}]];
        };
        
        if ([NSThread isMainThread]) {
            finishUp();
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                finishUp();
            });
        }
    }else if(instance && !show){
        void(^finishUp)(void) = ^() {
            [instance removeFromSuperview];
        };
        
        if ([NSThread isMainThread]) {
            finishUp();
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                finishUp();
            });
        }
    }else{
        void(^finishUp)(void) = ^() {
            [instance.indicator startAnimating];
            instance.hidden = !show;
        };
        
        if ([NSThread isMainThread]) {
            finishUp();
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                finishUp();
            });
        }
    }
    return instance;
}

+(instancetype _Nullable)show:(BOOL)show onView:(id _Nonnull)view withStyle:(UIActivityIndicatorViewStyle)style{
    return [self show:show onView:view withStyle:style andTint:NO];
}

+(instancetype)show:(BOOL)show onView:(id)view{
    return [self show:show onView:view withStyle:UIActivityIndicatorViewStyleGray andTint:NO];
}

+(instancetype)showOnTint:(BOOL)show onView:(id)view{
    return [self show:show onView:view withStyle:UIActivityIndicatorViewStyleWhite andTint:YES];
}

@end
