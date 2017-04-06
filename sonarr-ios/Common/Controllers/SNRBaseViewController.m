//
//  SNRBaseViewController.m
//  sonarr-ios
//
//  Created by Harry Singh on 12/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <MZFormSheetPresentationController/MZFormSheetPresentationViewController.h>
#import "SNRBaseViewController.h"
#import "UIAlertController+Show.h"
#import "SNRServerManager.h"
#import "SNRActivityIndicatorView.h"

@interface SNRBaseViewController ()
@end

@implementation SNRBaseViewController

#pragma mark - Life cycle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    if([self conformsToProtocol:@protocol(SNRServerManagerProtocol)]){
        [[SNRServerManager manager] addObserver:(id)self];
    }
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    NSLog(@"Memory");
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

#pragma mark - Protocol

+(UIStoryboard *)vcStoryboard{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+(NSString *)storyboardIdentifier{
    return [NSStringFromClass([self class]) stringByAppendingString:@"SBID"];
}

+(UIViewController *)viewController{
    return [[self vcStoryboard] instantiateViewControllerWithIdentifier:[self storyboardIdentifier]];
}

-(void)showSpinner:(BOOL)show{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SNRActivityIndicatorView showOnTint:show onView:self.view];
    });
}

#pragma mark - Notification

-(void)showMessage:(NSString *)message withTitle:(NSString *)title{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIAlertController alertWithTitle:title
                                  message:message
                               andActions:nil] show];
    });
}

@end
