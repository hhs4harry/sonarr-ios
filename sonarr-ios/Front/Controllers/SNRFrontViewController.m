//
//  SNRFrontViewController.m
//  Sonarr
//
//  Created by Harry Singh on 15/07/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRFrontViewController.h"
#import "UIColor+App.h"
#import "SNRSettingsViewController.h"
#import "SNRNavigationViewController.h"
#import "SNRPageViewController.h"

@interface SNRFrontViewController () <SNRSettingsProtocol>
@property (weak, nonatomic) IBOutlet UIView *navContentView;
@property (weak, nonatomic) IBOutlet UIView *settingsContainerView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) UITabBarItem *seriesTabBarItem;
@property (strong, nonatomic) UITabBarItem *searchTabBarItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBarBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingsContainerTopConstraint;
@property (strong, nonatomic) SNRSettingsViewController *settingsViewController;
@property (strong, nonatomic) SNRNavigationViewController *seriesNavigationController;
@property (strong, nonatomic) SNRPageViewController *pageViewController;
@property (strong, nonatomic) SNRNavigationViewController *searchNavigationController;
@end

@implementation SNRFrontViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tabBar setSelectedItem:self.seriesTabBarItem];
    [self.tabBar setTintColor:[UIColor primary]];
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"black"]];
    [self.seriesTabBarItem setTitlePositionAdjustment:UIOffsetMake(0.0f, -5.0f)];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"settingsSegue"]) {
        self.settingsViewController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"pageSegue"]){
        self.pageViewController = segue.destinationViewController;
        [self.pageViewController setTabViewControllers:@[self.seriesNavigationController, self.searchNavigationController]];
        [self.pageViewController setViewControllers:@[self.seriesNavigationController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        self.tabBar.items = @[self.seriesTabBarItem, self.searchTabBarItem];
    }
}

#pragma mark - Setters

-(void)setSettingsViewController:(SNRSettingsViewController *)settingsViewController{
    _settingsViewController = settingsViewController;
    
    settingsViewController.delegate = self;
}

#pragma mark - SNRSettingsProtocol

-(void)openSettings:(BOOL)open{
    if (open) {
        self.tabBarBottomConstraint.constant = -50;
        self.settingsContainerTopConstraint.constant = -[UIScreen mainScreen].bounds.size.height;
    } else {
        self.tabBarBottomConstraint.constant = 0;
        self.settingsContainerTopConstraint.constant = -100;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Getters/Setters

-(UITabBarItem *)seriesTabBarItem{
    if (!_seriesTabBarItem) {
        _seriesTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Series" image:[UIImage imageNamed:@"tv"] tag:0];
    }
    
    return _seriesTabBarItem;
}

-(UITabBarItem *)searchTabBarItem{
    if (!_searchTabBarItem) {
        _searchTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search" image:[UIImage imageNamed:@"search"] tag:1];
    }
    
    return _searchTabBarItem;
}

-(SNRNavigationViewController *)seriesNavigationController{
    if (!_seriesNavigationController) {
        _seriesNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"SNRSeriesNavigationViewControllerSBID"];
    }
    
    return _seriesNavigationController;
}

-(SNRNavigationViewController *)searchNavigationController{
    if (!_searchNavigationController) {
        _searchNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"SNRSearchNavigationViewControllerSBID"];
    }
    
    return _searchNavigationController;
}
@end
