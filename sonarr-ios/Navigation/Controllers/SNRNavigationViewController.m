//
//  SNRNavigationViewController.m
//  sonarr-ios
//
//  Created by Harry Singh on 12/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRNavigationViewController.h"
#import "SNRServerManagerViewController.h"
#import "SNRServerManager.h"
#import "SNRSeriesViewController.h"

@interface SNRNavigationViewController ()

@end

@implementation SNRNavigationViewController

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if([viewController conformsToProtocol:@protocol(SNRNavigationBarButtonProtocol)]){
        if([viewController respondsToSelector:@selector(backBarButton)]){
            viewController.navigationItem.leftBarButtonItem = [((id<SNRNavigationBarButtonProtocol> )viewController) backBarButton];
        }
        if([viewController respondsToSelector:@selector(rightBarButton)]){
            viewController.navigationItem.rightBarButtonItem = [((id<SNRNavigationBarButtonProtocol> )viewController) rightBarButton];
        }
    }
    [super pushViewController:viewController animated:animated];
}
@end
