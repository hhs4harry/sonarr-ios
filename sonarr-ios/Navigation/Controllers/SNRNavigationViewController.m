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

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *controller = [mainSB instantiateViewControllerWithIdentifier:[SNRServerManagerViewController storyboardIdentifier]];
    
    if([SNRServerManager manager].servers.count){
        controller = [mainSB instantiateViewControllerWithIdentifier:[SNRSeriesViewController storyboardIdentifier]];
    }
    
    //set root view controller
    [self pushViewController:controller animated:NO];
}

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
