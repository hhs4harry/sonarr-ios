//
//  SNRSettingsViewController.m
//  Sonarr
//
//  Created by Harry Singh on 14/07/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRSettingsViewController.h"
#import <MZFormSheetPresentationController/MZFormSheetPresentationViewController.h>

@interface SNRSettingsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SNRSettingsViewController

- (CGRect)contentViewFrameForPresentationController:(MZFormSheetPresentationController *)presentationController currentFrame:(CGRect)currentFrame {
    CGFloat viewW = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat viewH = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    return CGRectMake(0, 0, viewW, viewH);
}

@end
