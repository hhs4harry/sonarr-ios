//
//  SNRBaseViewController.m
//  sonarr-ios
//
//  Created by Harry Singh on 12/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRBaseViewController.h"
#import "UIAlertController+Show.h"
#import "SNRServerManager.h"
#import "SNRActivityIndicatorView.h"

@interface SNRBaseViewController ()
@property (strong, nonatomic) UIView *spinnerView;
@end

@implementation SNRBaseViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if([self conformsToProtocol:@protocol(SNRServerManagerProtocol)]){
        [[SNRServerManager manager] addObserver:(id)self];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self showSpinner:NO];
    [self.view endEditing:YES];
}

-(void)dealloc{
    if([self conformsToProtocol:@protocol(SNRServerManagerProtocol)]){
        [[SNRServerManager manager] removeObserver:(id)self];
    }
}

+(UIStoryboard *)vcStoryboard{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+(NSString *)storyboardIdentifier{
    return [NSStringFromClass([self class]) stringByAppendingString:@"SBID"];
}

-(void)showSpinner:(BOOL)show{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.spinnerView.hidden = !show;
    });
}

-(void)showMessage:(NSString *)message withTitle:(NSString *)title{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIAlertController alertWithTitle:title
                                  message:message
                               andActions:nil] show];
    });
}

#pragma mark - Getters

-(UIView *)spinnerView{
    if(!_spinnerView){
        UIView *newSpinner = [[UIView alloc] init];
        newSpinner.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        newSpinner.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view insertSubview:newSpinner atIndex:0];
        
        SNRActivityIndicatorView *indicatorView = [SNRActivityIndicatorView show:YES onView:newSpinner];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        
        [[NSLayoutConstraint constraintWithItem:newSpinner
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
        
        [[NSLayoutConstraint constraintWithItem:newSpinner
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
        
        [[NSLayoutConstraint constraintWithItem:newSpinner
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
        
        [[NSLayoutConstraint constraintWithItem:newSpinner
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
        
        _spinnerView = newSpinner;
    }
    return _spinnerView;
}

@end
