//
//  SNRSettingsViewController.m
//  Sonarr
//
//  Created by Harry Singh on 14/07/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRSettingsViewController.h"

@interface SNRSettingsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (assign, nonatomic) BOOL open;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@end

@implementation SNRSettingsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.open = NO;
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chevronTouchUpInide:)];
    self.view.gestureRecognizers = @[self.tap];
}

- (IBAction)chevronTouchUpInide:(id)sender {
    self.open = !self.open;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.addButton setHidden:!self.open];
    }];

    [self.tap setEnabled:!self.open];
    
    [self.delegate openSettings:self.open];
}

- (IBAction)addButtonTouchUpInside:(id)sender {
    
}

@end
