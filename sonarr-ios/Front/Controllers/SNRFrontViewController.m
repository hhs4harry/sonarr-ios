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

@interface SNRFrontViewController () <SNRSettingsProtocol>
@property (weak, nonatomic) IBOutlet UIView *navContentView;
@property (weak, nonatomic) IBOutlet UIView *settingsContainerView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *seriesTabBarItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBarBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingsContainerTopConstraint;
@property (strong, nonatomic) SNRSettingsViewController *settingsViewController;
@property (strong, nonatomic) SNRNavigationViewController *navigationController;
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
    } else if ([segue.identifier isEqualToString:@"navigationSegue"]){
        self.navigationController = segue.destinationViewController;
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

@end
